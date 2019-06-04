export default async function ({ route, redirect, store, app: { $axios, $cookies } }) {
  if (route.name === 'sign_in' || process.env.noAuth.includes(route.path) || store.getters['auth/isAuthenticated']) {
    return
  }
  const result = await store.dispatch('auth/trySetSession')

  if (!result) {
    redirect('/sign_in')
  }
}
