
export default function ({ store, app: { $axios, $cookies } }) {
  if (store.state.isAuthenticated) return
  const session = $cookies.get('session')
  // eslint-disable-next-line no-console
  console.log(store)
  if (session) {
    store.commit('auth/setSession', session)
  }
}
