<template>
    <v-row>
        <v-col class="text-center">
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
      items: [
        {
          src: '/images/a_codi_socks.png',
        },
        {
          src: '/images/codi_stickers.png',
        },
        {
          src: '/images/codi-tshirts.png',
        }
      ],
    };
  },
  methods: { 
    getImages() { 
      const apipath = 'http://backend:5000/images/';
      console.log(this.items); 
      axios.get(apipath)
        .then((res) => { 
            console.log(res);
            const imgpath = 'http://backend:5000/image/';

            for (let i = 0; i < res.data.data.length; i++) {
              this.items.push( {src: imgpath + res.data.data[i] }); 
              console.log(this.items); 
            }
        
        })
        .catch((error) => { 
            console.log(error); 
      }) 
    }
  },
  created() { 
    this.getImages(); 
  }
}
</script>
<style scoped>

</style>
