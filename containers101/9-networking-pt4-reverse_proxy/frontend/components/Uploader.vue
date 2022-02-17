<template>
    <v-container class="px-0" fluid>
        <v-form ref="form">
        <v-file-input
            label="File input"
            filled
            prepend-icon="mdi-camera"
            id="imageFile"
            v-model="imageFile"
            ></v-file-input>
        <v-radio-group v-model="category" mandatory> 
            <v-radio
                value="swag"
                :label="`Swag`"
            >
            </v-radio>

            <v-radio
                value="cookies"
                :label="`Cookies`"
            >
            </v-radio>

            <v-radio
                value="tea"
                :label="`Tea`"
            >
            </v-radio>   
        <span>Category is {{ category }}.</span>
        </v-radio-group>
        
        
        <v-container align="center" justify="center" class="submit">
            <v-btn rounded @click="postUpload">Submit</v-btn>
        </v-container>


        </v-form>
    </v-container>
</template>

<script>
import axios from 'axios';
axios.defaults.headers.post['Content-Type'] = 'multipart/form-data';
axios.defaults.headers['Access-Control-Allow-Origin'] = 'http://0.0.0.0:5000';

export default {
    data () {
      return {
        // make category selector
        category: 'swag',
        imageFile: ''
      }
    },
    methods: {
        postUpload() { 
            console.log(this.imageFile);
            console.log(this.category) ;
            let formData = new FormData();
            formData.append('cat', this.category);
            formData.append('pic', this.imageFile);
            // $nuxt.$emit('submit-images', this.imageFile);
            axios.post("http://0.0.0.0:5000/upload", formData)
            .then(result => console.log(result))
            .catch(e => console.log(e))
      
            this.loading = true
            setTimeout(() => (this.loading = false), 2000)
            this.$refs.form.reset()
        },
    }
            

  }
</script>

<style scoped>
    /* css goes here */
</style>