<template>
 
  <div class="carousal-wrapper">
    <v-container class="blog-container">
      <VueSlickCarousel :arrows="false" :dots="true" autoplay :speed="4000"  ref="slick" v-if="posts.length">
        
        <div :key="page.path" v-for="page in posts">
          <v-row align="center" class="carousal-slider-wrapper no-gutters">
            <v-col md="6" sm="6" xs="12" cols="12" p-0 >
              <div class="carousal-img">
              <router-link :to=" page.path" >
                <img
                  :src="
                    page.frontmatter.bannerimage
                      ? page.frontmatter.bannerimage
                      : 'default-banner.jpg'
                  "
                  :alt="page.frontmatter.title"
                />
                </router-link>
              </div>
            </v-col>
            <v-col md="6" sm="6"  cols="12">
              <div class="carousal-content">
                <div class="content-head">
                  <span>Featured / How-to Guides</span>
                </div>

                <span class="blog-date">{{ changeDateFormat(page.frontmatter.date) }}</span>
                <router-link :to="page.path" ><h5> {{ page.title }}</h5></router-link>
                <span class="mission">Developer advocates join our mission</span>
              </div>
            </v-col>
          </v-row>
        </div>
        
      </VueSlickCarousel>
       <div class="hot-press" data-aos="fade-left"
     data-aos-duration="800"  data-aos-delay="1500">
        <span>Hot off the Press</span>
        <div class="press-shape">
          <img :src="image" />
        </div>
      </div>
    </v-container>
  </div>
</template>

<script>
import VueSlickCarousel from "vue-slick-carousel";
import "vue-slick-carousel/dist/vue-slick-carousel.css";
import "vue-slick-carousel/dist/vue-slick-carousel-theme.css";
import arrowImage from "../uploads/arrow-pink.png";
import AOS from 'aos'
import 'aos/dist/aos.css'
export default {
  components: { VueSlickCarousel },
  props: ["posts"],
  data() {
    return {
      image: arrowImage,
      
    };
  },
  mounted(){
    AOS.init();
    
  },
  methods:{
    changeDateFormat(date){
      try {
        const dt = date.substring(0, 10) + "T12:00:00Z";
        return new Date(dt).toDateString();
      } catch (err) {
        return date.substring(0, 10);
      }
    }
  },
};
</script>

<style>
.carousal-wrapper {
  padding-bottom: 9px;
  font-family: "hk_grotesk";
}
.blog-container {
  margin-left: auto;
  margin-right: auto;
  max-width: 1080px;
  position: relative;
}

.carousal-wrapper
 .slick-dots  {
  background-color: transparent;
  bottom: 0;
  height: auto;
}


.carousal-wrapper .v-carousel__controls .v-item-group {
  overflow: hidden;
  display: flex;
  padding: 10px;
  align-items: center;
}
.carousal-wrapper
 .slick-dots li.slick-active {
  opacity: 1;
  color: #1e7cae;
}
.carousal-wrapper
  button::before {
  opacity: 1;
}
.carousal-wrapper .slick-dots {
  display: flex !important;
  align-items: center;
  justify-content: center;
}
.slick-dots li {
  width: auto;
  height: auto;
  display: flex;
  align-items: center;
  justify-content: center;
}
.carousal-wrapper
 .slick-dots li.slick-active button::hover:before {
  opacity: 1;
}
.carousal-wrapper .carousal-slider-wrapper {
  max-width: 1016px;
  overflow: hidden;
  background-color: #ffffff;
  border-radius: 20px;
  margin: 0 auto;
  align-items: stretch !important;
  box-shadow: 0px 2px 14px 0px rgba(0, 0, 0, 0.14);
  -webkit-box-shadow: 0px 2px 14px 0px rgba(0, 0, 0, 0.14);
  -moz-box-shadow: 0px 2px 14px 0px rgba(0, 0, 0, 0.14);
}

.carousal-wrapper .carousal-slider-wrapper .carousal-img img {
  width: 100%;
  object-fit: cover;
  height: 100%;
  min-height: 450px;
}
.carousal-wrapper .carousal-slider-wrapper .carousal-img {
  width: 100%;
  height: 100%;
}
.carousal-wrapper .carousal-content {
  padding: 60px 50px 60px 56px;
}
.carousal-wrapper .carousal-content span{
  font-size: 12px;
  line-height: 1.2;
  font-weight: 300;
}
.carousal-wrapper .content-head span {
  font-size: 14px;
  line-height: 1.3;
  font-weight: 700;
  color: #1e7cae;
  text-transform: uppercase;
}
.carousal-wrapper .content-head {
  padding-bottom: 49px;
  border-bottom: 1px solid #e5e6ed;
  margin-bottom: 36px;
}
.carousal-wrapper .blog-date {
  font-size: 12px;
  line-height: 22px;
  font-weight: 300;
  color: #000000;
  display: block;
  margin-bottom: 19px;
}
.carousal-wrapper .carousal-content h5 {
  font-size: 28px;
  line-height: 34px;
  font-weight: 500;
  color: #000000;
  margin-bottom: 13px;
  margin-top: 0;
}


.carousal-wrapper .v-image {
  padding: 30px 0;
}
.carousal-wrapper .v-item-group {
  padding-bottom: 35px;
}
.carousal-wrapper .hot-press {
  max-width: 121px;
  color: #fd8e81;
  position: absolute;
  transform: translateY(-50%);
  top: 50%;
  right: -120px;
}
.carousal-wrapper .hot-press span {
  font-size: 23px;
  line-height: 28px;
  text-transform: uppercase;
  font-family: "Max Sans";
  font-weight: 700;
}
.carousal-wrapper .carousal-content .mission{
    font-size: 18px;
  line-height: 28px;
  font-weight: 400;
  color: #000;
}
.carousal-wrapper .hot-press .press-shape {
  width: 28px;
}
.carousal-wrapper .hot-press .press-shape img {
  width: 100%;
}
.carousal-wrapper .slick-list{
  padding: 36px 0;
}
.carousal-wrapper .slick-prev,.carousal-wrapper .slick-next{
  display: none;
}
.carousal-wrapper .slick-dots li{
cursor: pointer;
}
.carousal-wrapper .slick-dots li button  {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background-color: #1E7CAE;
  opacity: 0.5;
  
}
.slick-dots li button:before {
  content: none;
}
.carousal-wrapper .slick-dots li.slick-active button{
  opacity: 1;
  width: 14px;
  height: 14px;
}
.carousal-wrapper .slick-slide{
  padding: 0 20px;
}
.carousal-wrapper .slick-slider{
  padding-bottom: 9px;
}

</style>
