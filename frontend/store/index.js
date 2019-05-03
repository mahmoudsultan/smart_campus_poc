export const state = () => ({
  user: null,
  auth: {}
})

export const mutations = {
  user(state, value) {
    state.user = value
  },
  auth(state, value) {
    state.auth = value
  }
}
export const getters = {
  isAuthenticated(state) {
    return state.user && state.auth
  }
}
