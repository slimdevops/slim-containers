<template>
    <v-container class="px-0" fluid>
        <v-form ref="form">
        <v-file-input
            label="File input"
            filled
            prepend-icon="mdi-camera"
            ></v-file-input>
        <v-radio-group v-model="category"> 
            <v-radio
                :label="`Swag`"
            >
            </v-radio>

            <v-radio
                :label="`Cookies`"
            >
            </v-radio>

            <v-radio
                :label="`Tea`"
            >
            </v-radio>
        </v-radio-group>
        
        <v-btn
          color="primary"
          @click="postUpload"
        >

        </v-form>
    </v-container>
</template>

<script>
import axios from 'axios';

export default {
    data () {
      return {
        // make category selector
        category: ''
      }
    },
    methods: {
        postUpload() { 
            console.log(this.category);
        }
    }
  }
</script>

<style scoped>
    /* css goes here */
</style>