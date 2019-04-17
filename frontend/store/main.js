import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import axios from 'axios'
import vueCookie from 'vue-cookie'
import status from 'http-status'
import { pick } from 'lodash'

// Put your instance of Axios in `Vue.prototype` which gives you easy global access to it.
// You can pass in configuration that is shared application-wide.
Vue.prototype.$http = axios.create()

// This first fat arrow function defines a callback invoked after any SUCCESSFUL request.
// This is where we check if the backend included an `access-token` header.
Vue.prototype.$http.interceptors.response.use((response) => {
  if (response.headers['access-token']) {
    // Commits the relevant headers to the store, calling mutation `auth`.
    const authHeaders = pick(r.headers, ["access-token","client","expiry","uid","token-type"])
    store.commit('auth', authHeaders)

    var session = vueCookie.get('session')

    // Stores the tokens in a cookie called `session` too. Cookie values are strings, so have to
    // serialize it to JSON.
    //
    // The object we are storing in session looks like this:
    // {'tokens': {'access-token': 'foo', ...}, 'user': {'email': 'foo@bar.com', ...}}
    // so that is why we are extracting and modifying, so that the `user` key isn't blown away.
    if (session) {
      var session = JSON.parse(session)
      session['tokens'] = authHeaders

      vueCookie.set('session', JSON.stringify(session), { expires: '14D' })
    }
  }

  return response
}, (error) => {
  // This second fat arrow function defines a callback invoked after any FAILED request.
  // This handles every case when the server responds with a 403 / unauthorized. That means
  // we need to redirect the user to the SignIn component.
  if (router.currentRoute.name !== 'signin' && error.response.status === status.UNAUTHORIZED) {
    store.commit('user', null)
    router.push({ name: 'signin' })
  }

  return Promise.reject(error)
})
