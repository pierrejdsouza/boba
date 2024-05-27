# Create a key ring for terraform state bucket
resource "google_kms_key_ring" "tf_states" {
  name     = "tfstate-key-ring-test-02"
  location = "asia"

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create a key within the key ring for terraform state bucket
resource "google_kms_crypto_key" "tf_states" {
  name = "tfstate-key-01"
  key_ring = google_kms_key_ring.tf_states.id
  rotation_period = "100000s"

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create a key ring for static website content
resource "google_kms_key_ring" "boba_sw" {
  name = "boba-content-key-ring-test-02"
  location = "asia"

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create a key within the key ring for static website content
resource "google_kms_crypto_key" "boba_sw" {
  name = "bobac-key-01"
  key_ring = google_kms_key_ring.boba_sw.id
  rotation_period = "100000s"

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create binding so storage can encrypt and decrypt using our keys for both buckets
resource "google_kms_crypto_key_iam_binding" "binding" {
  crypto_key_id = google_kms_crypto_key.tf_states.id
  role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = ["serviceAccount:service-253750488491@gs-project-accounts.iam.gserviceaccount.com"]
}

resource "google_kms_crypto_key_iam_binding" "swbinding" {
  crypto_key_id = google_kms_crypto_key.boba_sw.id
  role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = ["serviceAccount:service-253750488491@gs-project-accounts.iam.gserviceaccount.com"]
}

# Create our terraform state bucket
resource "google_storage_bucket" "default" {
  name          = "boba-bucket-tfstate"
  force_destroy = false
  location      = "ASIA"
  storage_class = "STANDARD"
  public_access_prevention = "enforced"
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = google_kms_crypto_key.tf_states.id
  }
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Creating a comment, no changes to the app but changes in other files

# Create our static website bucket
resource "google_storage_bucket" "bucket_1" {
  name                        = "20240524-boba-bucket"
  location                    = "ASIA"
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"
  // delete bucket and contents on destroy.
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  encryption {
    default_kms_key_name = google_kms_crypto_key.boba_sw.id
  }
}

# Make buckets public
resource "google_storage_bucket_iam_member" "bucket_1" {
  bucket = google_storage_bucket.bucket_1.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Reserve IP address
resource "google_compute_global_address" "default" {
  name = "boba-ip"
}

# Create LB backend buckets
resource "google_compute_backend_bucket" "bucket_1" {
  name        = "boba-backend"
  bucket_name = google_storage_bucket.bucket_1.name
  # security_policy = google_compute_security_policy.cloud_armor_policy.id
}

# Create url map
resource "google_compute_url_map" "default" {
  name = "boba-http-lb"

  default_service = google_compute_backend_bucket.bucket_1.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "path-matcher"
  }
  path_matcher {
    name            = "path-matcher"
    default_service = google_compute_backend_bucket.bucket_1.id
  }
}

# Create HTTP target proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "boba-http-lb-proxy"
  url_map = google_compute_url_map.default.id
}

# Create forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "http-lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

output "web_url" {
  value = google_compute_global_forwarding_rule.default.ip_address
}
