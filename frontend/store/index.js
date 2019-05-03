const getDefaultState = () => {
  return {
    user: { name: 'user' },
    auth: {}
  }
}

export const state = getDefaultState

export const mutations = {
  user(state, value) {
    state.user = value
  },
  auth(state, value) {
    state.auth = value
  },
  resetState(state) {
    Object.assign(state, getDefaultState())
  }
}
export const getters = {
  isAuthenticated(state) {
    return state.user && state.auth
  }
}
