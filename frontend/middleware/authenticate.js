export default function ({ route, redirect, store, app: { $axios, $cookies } }) {
  if (route.name === 'sign_in' || process.env.noAuth.includes(route.path) || store.getters['auth/isAuthenticated']) {
    return
  }

  const session = $cookies.get('session')

  if (session) {
    store.commit('auth/setSession', session)
  } else {
    redirect('/sign_in')
  }
}
