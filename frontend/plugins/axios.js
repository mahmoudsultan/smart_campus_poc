
// import { pick } from 'lodash'
export default function ({ store, app: { $axios }, route, redirect }) {
  // $axios.onResponse((response) => {
  //   if (response.headers['access-token']) {
  //     pick(response.headers,
  //       ['access-token', 'client', 'expiry', 'uid', 'token-type'])
  //       .forEach((item, key) => {
  //         $axios.setHeader(key, item)
  //       })
  //   }
  //   return response
  // })

  // $axios.onRequest((config) => {
  //   const headers = store.getters.auth

  //   // object that holds configuration of the request that's about to be made
  //   config.headers = headers
  //   return config
  // })

  $axios.onResponseError((error) => {
    if (route.name !== 'sign_in' && error.response.status === 401) {
      store.commit('user', null)
      redirect('/sign_in')
    }
    return Promise.reject(error)
  })
}
