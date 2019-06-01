import { pick } from 'lodash'
import { Ability } from '@casl/ability'

export const ability = new Ability()

const getDefaultState = () => {
  return {
    user: { name: 'User', role: '-' },
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
    ability.update(roles)
  },
  destroySession(state) {
    Object.assign(state, getDefaultState())
  }

}

export const actions = {
  setHeaders({ commit }, response) {
    const authHeaders = pick(response.headers,
      ['access-token', 'client', 'uid'])

    commit('headers', authHeaders)
    const store = this
    store.$axios.get('/users/roles').then((rolesResponse) => {
      const session = {
        headers: authHeaders,
        user: response.data.data,
        roles: rolesResponse.data.roles
      }
      commit('setSession', session)

      store.$cookies.set('session', JSON.stringify(session))
    })
  },

  signIn({ dispatch, commit }, { email, password }) {
    return new Promise((resolve, reject) => {
      this.$axios.post('/auth/sign_in', { email: email, password: password })
        .then((response) => {
          dispatch('setHeaders', response)

          resolve()
        }).catch((error) => {
          reject(error)
        })
    })
  },
  signUp({ dispatch, commit }, { email, password, name, department, role }) {
    return new Promise((resolve, reject) => {
      this.$axios.post('/auth', { email: email,
        password: password,
        name: name,
        department: department,
        role: role })
        .then((response) => {
          dispatch('setHeaders', response)
          resolve()
        })
    })
  },
  logout({ commit }) {
    commit('destroySession')
    this.$cookies.remove('session')
  }
}
function isEmpty(obj) {
  for (const key in obj) {
    if (obj.hasOwnProperty(key)) { return false }
  }
  return true
}

export const getters = {
  isAuthenticated(state) {
    return !isEmpty(state.headers)
  },
  user(state) {
    return state.user
  }
}
