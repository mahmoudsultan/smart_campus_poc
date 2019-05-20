import { abilitiesPlugin } from '@casl/vue'
import Vue from 'vue'
import { ability } from '@/store/auth'

Vue.use(abilitiesPlugin, ability)
