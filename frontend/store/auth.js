import { pick } from 'lodash'
import { Ability } from '@casl/ability'

export const ability = new Ability()

const getDefaultState = () => {
  return {
    user: { name: 'User', role: '-', avatars: [] },
    headers: {},
    roles: [],
    deletedAvatarsIds: []
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
    const userNoAvatars = JSON.parse(JSON.stringify(user))
    userNoAvatars.avatars = []
    saveToLocalStorage('avatars', JSON.stringify(user.avatars))
    this.$cookies.set('session', JSON.stringify({ headers: headers, user: userNoAvatars, roles: roles }))
  },
  destroySession(state) {
    Object.assign(state, getDefaultState())
    this.$cookies.remove('session')
    removeFromLocalStorage('avatar')
  },
  addAvatar(state, imageB64) {
    const startOffset = 10000
    const ids = state.user.avatars.map(a => a.id)

    const id = startOffset + (ids.length ? Math.max(...ids) : 0)

    state.user.avatars.push({ id: id, image: imageB64, isLocal: true })
  },
  setAvatarsList(state, avatars) {
    state.user.avatars = avatars
  },
  deleteAvatar(state, id) {
    const avatarObj = state.user.avatars.filter(a => a.id === id)[0]
    if (!avatarObj.hasOwnProperty('isLocal')) {
      state.deletedAvatarsIds.push(avatarObj.id)
    }
    state.user.avatars = state.user.avatars.filter(a => a.id !== id)
  }

}

export const actions = {
  trySetSession({ commit }) {
    return new Promise((resolve, reject) => {
      const session = this.$cookies.get('session')
      if (session) {
        session.avatars = getFromLocalStorage('avatars')
        commit('setSession', session)
        resolve(true)
      } else {
        resolve(false)
      }
    })
  },
  fetchAvatars({ commit }) {
    commit('setAvatarsList', JSON.parse(getFromLocalStorage('avatars')))
  },
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
  signUp({ dispatch }, { email, password, name, department, role }) {
    return new Promise((resolve, reject) => {
      this.$axios.post('/auth', { email: email,
        password: password,
        name: name,
        department: department,
        role: role })
        .then((response) => {
          dispatch('setHeaders', response)
          resolve(response)
        }).catch((error) => {
          reject(error)
        })
    })
  },
  sendUpdates({ commit, state }) {
    return new Promise(async (resolve, reject) => {
      const updateResponse = await this.$axios.put('/auth', state.user)
      const deletedAvatarsObj = { data: JSON.stringify({ avatars: state.deletedAvatarsIds }) }
      const deletedIds = (await this.$axios.delete('/users/avatars', deletedAvatarsObj)).data.ids
      // eslint-disable-next-line no-console
      // console.log(deletedIds)
      const newUser = updateResponse.data.data

      newUser.avatars = newUser.avatars.filter(a => deletedIds.indexOf(a.id) === -1)
      // eslint-disable-next-line no-console
      // console.log(newUser)
      commit('setSession', { headers: state.headers, user: newUser, roles: state.roles })
      state.deletedAvatars = []
      resolve(newUser)
    })
  },
  logout({ commit }) {
    commit('destroySession')
  }
}
function isEmpty(obj) {
  for (const key in obj) {
    if (obj.hasOwnProperty(key)) { return false }
  }
  return true
}

function saveToLocalStorage(key, value) {
  if (process.client) {
    localStorage.setItem(key, value)
    return true
  } else {
    return false
  }
}
function getFromLocalStorage(key) {
  if (process.client) {
    return localStorage.getItem(key)
  } else {
    return []
  }
}

function removeFromLocalStorage(key) {
  if (process.client) {
    localStorage.removeItem(key)
    return true
  } else {
    return false
  }
}
export const getters = {
  isAuthenticated(state) {
    return !isEmpty(state.headers)
  },
  user(state) {
    return state.user
  }
}
