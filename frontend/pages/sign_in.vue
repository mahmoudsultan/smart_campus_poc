<template>
  <div />
</template>

<script>
import { pick } from 'lodash'

export default {
  methods: {
    signIn() {
      this.$axios.post('/auth/sign_in', { email: this.email, password: this.password })
        .then((response) => {
          const authHeaders = pick(response.headers,
            ['access-token', 'client', 'expiry', 'uid', 'token-type'])
          this.$store.commit('auth', authHeaders)
          this.$store.commit('user', response.data.data)
          const cookieContent = {
            tokens: authHeaders,
            user: response.data.data
          }
          this.$cookie.set('session', JSON.stringify(cookieContent), { expires: '14D' })
          this.$router.push({ name: 'home' })
        })
    }
  }
}
</script>

<style>

</style>
