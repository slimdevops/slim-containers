<template>
    <v-row>
        <v-col v-if="doneGettingItems" class="text-center">
            <v-carousel>
                <v-carousel-item
                    v-for="(item,i) in items"
                    :key="i"
                    :src="item.src"
                    reverse-transition="fade-transition"
                    transition="fade-transition"
                    ></v-carousel-item>
            </v-carousel>
        </v-col>
    </v-row>
</template>

<script>
import axios from 'axios';
axios.defaults.baseURL = "http://0.0.0.0"
axios.defaults.headers['Access-Control-Allow-Origin'] = '*';
axios.defaults.headers['Access-Control-Allow-Methods'] = 'GET,PUT,POST,DELETE,PATCH,OPTIONS'

export default {
  data () {
    return {
      items: [{ 
        src: "http://0.0.0.0:5000/image/Tea3.png"
      }],
      doneGettingItems: false,
    }
  },
  methods: { 
    getImages() { 
      const apipath = 'http://0.0.0.0:5000/images/';
      console.log(this.items); 
      var config = {
        headers: {'Access-Control-Allow-Origin': '*'}
      };
      axios.get(apipath,{},config)
        .then((res) => { 
            console.log(res);
            const imgpath = 'http://0.0.0.0:5000/image/';

            for (let i = 0; i < res.data.images.length; i++) {
              this.items.push( {src: imgpath + res.data.images[i][1] }); 
            }
            this.doneGettingItems = true;
        })
        .catch((error) => { 
            this.doneGettingItems = true;
      }) 
    }
  },
  created () {
    this.getImages();  
    console.log("Got new images from backend.");
  }
}
</script>
<style scoped>

</style>
