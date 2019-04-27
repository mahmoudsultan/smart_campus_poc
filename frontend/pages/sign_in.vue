<template>
  <form>
    <v-text-field
      v-model="email"
      label="E-mail"
      required
    />
    <v-text-field
      v-model="password"
      :append-icon="showPassword ? 'visibility' : 'visibility_off'"
      :type="showPassword ? 'text' : 'password'"
      @click:append="showPassword = !showPassword"
      name="password"
      required
      label="Password"
      hint="At least 8 characters"
    />
    <v-btn @click="signIn">
      sign in
    </v-btn>
  </form>
</template>

<script>
import { pick } from 'lodash'

export default {
  data: () => ({
    showPassword: false,
    password: '',
    email: ''
  }),
  computed: {

  },
  mounted() {

  },
  methods: {
    signIn() {
      // eslint-disable-next-line no-console
      console.log(`sign in with ${this.password}, ${this.email}`)
      this.$axios.post('/auth/sign_in', { email: this.email, password: this.password })
        .then((response) => {
          const authHeaders = pick(response.headers,
            ['access-token', 'client', 'expiry', 'uid', 'token-type'])
          this.$store.commit('auth', authHeaders)
          this.$store.commit('user', response.data.data)
          this.$router.push({ name: 'timetable' })
        })
    }
  }
}
</script>

<style>

</style>
