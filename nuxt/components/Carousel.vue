<template>
  <v-row>
    <v-col class="text-center">
      <v-carousel class="someclass">
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
          },
        ],
      }
    },
  }
</script>
<style scoped>

</style>

