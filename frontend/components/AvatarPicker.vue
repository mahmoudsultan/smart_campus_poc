<template>
  <v-card>
    <v-layout row wrap>
      <v-flex
        v-for="avatar in avatars"
        :key="avatar.id"
        xs4
        sm3
        d-flex
      >
        <v-card tile flat class="d-flex">
          <v-card-text class="d-flex">
            <v-badge overlap class="avatar-picker-avatar">
              <template
                v-slot:badge
              >
                <v-icon @click="removeAvatar(avatar)">
                  close
                </v-icon>
              </template>

              <v-avatar
                @click="selectAvatar(avatar)"
                size="96"
              >
                <img :src="avatar.image">
              </v-avatar>
            </v-badge>
          </v-card-text>
        </v-card>
      </v-flex>
    </v-layout>
    <v-card-text>
      {{ avatars.length == 0? 'You have not uploaded any images yet' : '' }}
      <v-card-text>
        <v-card-actions>
          <vue-base64-file-upload
            @load="onLoad"
          /></vue-base64-file-upload>
        </v-card-actions>
      </v-card-text>
    </v-card-text>
  </v-card>
</template>

<script>
import VueBase64FileUpload from '@/components/VueBase64FileUpload'

export default {
  name: 'AvatarPicker',
  components: { VueBase64FileUpload },
  props: {
    avatars: {
      type: Array,
      required: true
    },
    accept: {
      type: String,
      default: 'image/png,image/jpeg,image/jpg'
    }
  },
  methods: {
    onLoad(base64Image) {
      this.$emit('load', base64Image)
    },
    removeAvatar(avatar) {
      // eslint-disable-next-line no-console
      // console.log('remove')

      this.$emit('remove', avatar.id)
    },
    selectAvatar(avatar) {
      // eslint-disable-next-line no-console
      // console.log('select')
      this.$emit('select', avatar.id)
    }
  }
}
</script>
<style lang="stylus">
.avatar-picker-avatar {
    cursor: pointer;
    opacity: .5;
    transition: all .1s ease-in-out;

    &:hover, &.current {
        opacity: 1;
    }
}
</style>
