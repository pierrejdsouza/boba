<template>
  <div class="profile-card">
    <div class="profile-header">
      <img :src="require('@/assets/profile.png')" alt="Profile Picture" class="profile-picture" />
      <div class="profile-details">
        <h1>Pierre D'Souza</h1>
        <h2>Solutions Architect</h2>
      </div>
    </div>
    <div class="about-me-section">
      <h3>About Me</h3>
      <p>
        An IT whiz whose dreams of becoming a pilot were sidetracked by the advent of the Internet. 
        With more than 15 years of experience in cloud computing and virtualization across AWS, Azure, and GCP. 
        I specialize in containerization, serverless architectures, and the strategic deployment of scalable, 
        resilient infrastructure solutions. My technical expertise includes orchestrating Kubernetes environments 
        and leading significant cloud migration and modernization projects, ensuring seamless transitions and 
        operational excellence.
      </p>
    </div>
    <div class="cat-gallery">
      <div class="cat-item" v-for="(cat, index) in cats" :key="index">
        <img :src="require(`@/assets/${cat.src}`)" :alt="cat.name" class="cat-picture" />
        <div class="cat-caption">{{ cat.caption }}</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProfileBox',
  data() {
    return {
      cats: [
        { src: 'toby.jpg', name: 'Cat 1', caption: 'Toby' },
        { src: 'kechik.jpg', name: 'Cat 2', caption: 'Kechik' },
        // { src: 'oreo.jpg', name: 'Cat 3', caption: 'Oreo' }
      ]
    };
  }
};
</script>

<style scoped>
.profile-card {
  max-width: 800px;
  margin: 50px auto;
  padding: 20px;
  border: 1px solid #dbdbdb;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  background-color: #ffffff;
  font-family: Arial, sans-serif;
  color: #333333;
  text-align: center;
}

.profile-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 20px;
}

.profile-picture {
  width: 150px;
  height: 150px;
  border-radius: 50%;
  object-fit: cover;
  margin-bottom: 20px;
}

.profile-details h1 {
  margin: 0;
  font-size: 24px;
}

.profile-details h2 {
  margin: 0;
  font-size: 20px;
  color: #666666;
}

.about-me-section {
  margin: 20px 0;
}

.about-me-section h3 {
  font-size: 18px;
  margin-bottom: 10px;
  color: #333333;
}

.cat-gallery {
  display: flex;
  justify-content: space-around;
  flex-wrap: wrap;
}

.cat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 200px;
  background-color: #fafafa;
  color: #333333;
  border: 1px solid #dbdbdb;
  border-radius: 10px;
  margin-bottom: 20px;
  text-align: center;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.cat-picture {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-radius: 10px 10px 0 0;
}

.cat-caption {
  font-size: 16px;
  padding: 10px;
}
</style>
