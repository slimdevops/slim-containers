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
      axios.get(apipath)
        .then((res) => { 
            console.log(res);
            const imgpath = 'http://0.0.0.0:5000/';

            for (let i = 0; i < res.data.images.length; i++) {
              this.items.push( {src: imgpath + res.data.images[i] }); 
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
    console.log(this.items);
  }
}
</script>
<style scoped>

</style>
