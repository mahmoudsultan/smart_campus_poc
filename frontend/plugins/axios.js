
import { pick } from 'lodash'
export default function ({ store, app: { $axios, $router } }) {
  $axios.onResponse((response) => {
    if (response.headers['access-token']) {
      pick(response.headers,
        ['access-token', 'client', 'expiry', 'uid', 'token-type'])
        .forEach((item, key) => {
          $axios.setHeader(key, item)
        })
    }
    return response
  })

  // $axios.onRequest((config) => {
  //   const headers = store.getters.auth

  //   // object that holds configuration of the request that's about to be made
  //   config.headers = headers
  //   return config
  // })

  $axios.onResponseError((error) => {
    if ($router.currentRoute.name !== 'sign_in' && error.response.status === status.UNAUTHORIZED) {
      store.commit('user', null)
      $router.push({ name: 'sign_in' })
    }

    return Promise.reject(error)
  }

  )
}
