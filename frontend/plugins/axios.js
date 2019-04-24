import Vue from 'vue'
import axios from 'axios'
import vueCookie from 'vue-cookie'
import status from 'http-status'
import { pick } from 'lodash'
import store from './store'
import router from './router'

axios.interceptors.response.use((response) => {
  if (response.headers['access-token']) {
    // Commits the relevant headers to the store, calling mutation `auth`.
    const authHeaders = pick(response.headers,
      ['access-token', 'client', 'expiry', 'uid', 'token-type'])
    store.commit('auth', authHeaders)

    let session = vueCookie.get('session')

    // Stores the tokens in a cookie called `session` too. Cookie values are strings, so have to
    // serialize it to JSON.
    //
    // The object we are storing in session looks like this:
    // {'tokens': {'access-token': 'foo', ...}, 'user': {'email': 'foo@bar.com', ...}}
    // so that is why we are extracting and modifying, so that the `user` key isn't blown away.
    if (session) {
      session = JSON.parse(session)
      session.tokens = authHeaders

      vueCookie.set('session', JSON.stringify(session), { expires: '14D' })
    }
  }

  return response
}, (error) => {
  if (router.currentRoute.name !== 'signin' && error.response.status === status.UNAUTHORIZED) {
    store.commit('user', null)
    router.push({ name: 'signin' })
  }

  return Promise.reject(error)
})
axios.interceptors.request.use((config) => {
  const headers = store.getters.auth

  // object that holds configuration of the request that's about to be made
  config.headers = headers
  return config
})

Vue.use(axios)
