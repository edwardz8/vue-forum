import Vue from 'vue'
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

import { CHECK_AUTH } from './store/actions.type'
import ApiService from './common/api.service'
import DateFilter from './common/date.filter'
import ErrorFilter from './common/error.filter'

Vue.config.productionTip = false 
Vue.filter('date', DateFilter)
Vue.filter('error', ErrorFilter)

ApiService.init()

// check auth before each page load 
router.beforeEach((to, from, next) => 
    Promise.all([store.dispatch(CHECK_AUTH)]).then(next)
)

createApp(App).use(store).use(router).mount('#app')
