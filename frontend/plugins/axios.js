// import vueCookie from 'vue-cookie'

// import { pick } from 'lodash'
export default function ({ store, app: { $axios }, route, redirect }) {
  $axios.onResponse((res) => {
    // store.dispatch('auth/setHeaders', res)
  })
  $axios.onRequest((config) => {
    const authHeaders = store.state.auth.headers

    for (const header in authHeaders) {
      config.headers[header] = authHeaders[header]
    }

    return config
  })

  $axios.onResponseError((error) => {
    if (route.name !== 'sign_in' && error.response.status === 401) {
      redirect('/sign_in')
    }
    return Promise.reject(error)
  })
}
