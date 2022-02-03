<template>
    <v-container class="px-0" fluid>
        <v-file-input
            label="File input"
            filled
            prepend-icon="mdi-camera"
            ></v-file-input>

        <v-checkbox
            v-model="checked"
            :label="`Swag`"
        >
        </v-checkbox>
        <v-checkbox
            v-model="unchecked"
            :label="`Cookies`"
        >
        </v-checkbox>

        <v-checkbox
            v-model="unchecked"
            :label="`Cookies`"
        >
        </v-checkbox>

        <v-checkbox
            v-model="unchecked"
            :label="`Tea`"
        >
        </v-checkbox>
    </v-container>
</template>

<script>
export default {
    data () {
      return {
        checked: true,
        unchecked: false
      }
    },
  }
</script>

<style scoped>
    /* css goes here */
</style>