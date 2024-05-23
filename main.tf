resource "google_storage_bucket" "default" {
  name          = "boba-bucket-tfstate"
  force_destroy = false
  location      = "ASIA"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# # Create Cloud Storage buckets
# resource "random_id" "bucket_prefix" {
#   byte_length = 8
# }

# Creating a comment, no changes to the app but changes in other files

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
