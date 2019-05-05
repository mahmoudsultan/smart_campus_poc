import { pick } from 'lodash'
import { Ability } from '@casl/ability'

export const ability = new Ability()

const getDefaultState = () => {
  return {
    user: { name: 'user' },
    headers: {},
    roles: []
  }
}

export const state = getDefaultState

export const mutations = {
  user(state, value) {
    state.user = value
  },
  headers(state, value) {
    state.headers = value
  },
  setSession(state, { headers, user, roles }) {
    state.headers = headers
    state.user = user
    state.roles = roles
  },
  destroySession(state) {
    Object.assign(state, getDefaultState())
  }

}
function setHeaders(response, store, commit) {
  const authHeaders = pick(response.headers,
    ['access-token', 'client', 'uid'])
  // eslint-disable-next-line no-console
  console.log('apppppppppppp')
  // eslint-disable-next-line no-console
  console.log(store.app.$ability)
  store.$axios.get('/users/roles').then((response) => {
    // eslint-disable-next-line no-console
    console.log(response)
    ability.update(response.data.roles)
    const session = {
      headers: authHeaders,
      user: response.data.data,
      roles: ability
    }
    // eslint-disable-next-line no-console
    console.log(ability)
    commit('setSession', session)
    store.$cookies.set('session', JSON.stringify(session))
  })
}

export const actions = {

  signIn({ commit }, { app, email, password }) {
    return new Promise((resolve, reject) => {
      this.$axios.post('/auth/sign_in', { email: email, password: password })
        .then((response) => {
          setHeaders(response, this, commit)
          resolve()
        })
    })
  },
  signUp({ commit }, { email, password, name, department, role }) {
    return new Promise((resolve, reject) => {
      this.$axios.post('/auth', { email: email,
        password: password,
        name: name,
        department: department,
        role: role })
        .then((response) => {
          setHeaders(response, this, commit)
          resolve()
        })
    })
  },
  logout({ commit }, { app }) {
    commit('destroySession')
    this.$cookies.remove('session')
  }
}

export const getters = {
  isAuthenticated(state) {
    return state.user && state.auth
  }
}
