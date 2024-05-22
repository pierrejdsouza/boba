<template>
  <div id="app">
    <ProfileBox />
  </div>
</template>

<script>
import ProfileBox from './components/ProfileBox.vue';

export default {
  name: 'App',
  components: {
    ProfileBox
  }
};
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  background-color: #fafafa;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
