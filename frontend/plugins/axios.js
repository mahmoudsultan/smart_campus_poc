// import vueCookie from 'vue-cookie'

// import { pick } from 'lodash'
export default function ({ store, app: { $axios }, route, redirect }) {
  $axios.onResponse((res) => {
    // eslint-disable-next-line no-console
    console.log('axiossssssssssssss response')
    // eslint-disable-next-line no-console
    console.log(res)
  })
  $axios.onRequest((config) => {
    // eslint-disable-next-line no-console
    console.log('axiossssssssssssss')
    // eslint-disable-next-line no-console
    console.log(store.state)
    const authHeaders = store.state.auth.headers
    // eslint-disable-next-line no-console
    console.log(authHeaders)
    for (const header in authHeaders) {
      config.headers[header] = authHeaders[header]
    }
    // eslint-disable-next-line no-console
    console.log('configggg')
    // eslint-disable-next-line no-console
    console.log(config)

    return config
  })

  $axios.onResponseError((error) => {
    if (route.name !== 'sign_in' && error.response.status === 401) {
      redirect('/sign_in')
    }
    return Promise.reject(error)
  })
}
