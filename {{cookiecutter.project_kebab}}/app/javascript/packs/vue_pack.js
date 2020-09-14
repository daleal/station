import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  if (document.getElementById('hello')) {
    new Vue({
      render: (h) => h(App),
    }).$mount('#hello');
  }
})
