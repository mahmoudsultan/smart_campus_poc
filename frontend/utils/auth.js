import { pick } from 'lodash'

function setAuthState(app, response) {
  const authHeaders = pick(response.headers,
    ['access-token', 'client', 'uid'])
  app.$store.commit('auth', authHeaders)
  app.$store.commit('user', response.data.data)

  const session = {
    tokens: authHeaders,
    user: response.data.data
  }

  app.$cookies.set('session', JSON.stringify(session))
}

function resetAuthState(app, response) {
  app.$store.commit('resetState')
  app.$cookies.remove('session')
}

export { setAuthState, resetAuthState }
