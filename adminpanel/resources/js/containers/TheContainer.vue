<template>
    <div id="app">
        <div id="sidebar" class="active">
            <div class="sidebar-wrapper active">
                <div class="sidebar-header">
<!--                    <div class="d-flex justify-content-between">-->
                    <div class="d-flex flex-row justify-content-center">
                        <div class="logo">
                            <router-link to="/" class="d-flex flex-column align-items-center justify-content-center align-content-center flex-wrap ">
                                <img class="container-logo" v-if="$appLogo != ''" :src="$storageUrl+$appLogo" alt='Logo' srcset=""/>
                                <img class="container-logo" v-else :src="$baseUrl + '/images/logo.png'" alt='Logo' srcset=""/>
                                <span style="font-size: 21px;" >{{ $appName }}</span>
                            </router-link>
                        </div>
                        <div class="toggler">
                            <a href="javascript:void(0)" class="sidebar-hide d-xl-none d-block"><i class="bi bi-x bi-middle"></i></a>
                        </div>
                    </div>
                </div>
                <div class="sidebar-menu">
                    <ul class="menu">

                        <li class="sidebar-item sidebar-search">
                            <b-form-input v-model="search" type="search" :placeholder="__('search')"
                                          v-on:keyup="filterItem" v-on:search="filterItem"></b-form-input>
                        </li>

                        <!-- <li class="sidebar-title">Menu</li> -->
                        <template v-for="item in filteredSidebarItems">
                            <li class="sidebar-item" :class="{ 'active' : isActive(item.url) || subIsActive(item), 'has-sub' : isHasSub(item) }"
                                v-if=" item.role==true ? ($role('Super Admin') && (item.name=='Role' || item.name=='System Users')) : (item.permission && $can(item.permission) )">
                                <!--
                                v-if="$can(item.permission)"
                                -->
                                <template v-if="isHasSub(item)">
                                    <a class="sidebar-link">
                                        <i :class="`fa fa-${item.icon}`"></i>
                                        <span>{{ item.name }}</span>
                                    </a>
                                    <ul class="submenu" :class="{ 'active' : subIsActive(item) } ">
                                        <template v-for="sub in item.submenu">
                                            <li class="submenu-item" :class="{ 'active' : isActive(sub.url) } " :key="sub.key">
                                                <router-link :to="sub.url" @click="closeSideBarMenu()">
                                                    {{ sub.name }}
                                                </router-link>
                                            </li>
                                        </template>
                                    </ul>
                                </template>
                                <template v-else>
                                    <router-link class="sidebar-link" :to="item.url" @click="closeSideBarMenu()">
                                        <i :class="`fa fa-${item.icon}`"></i>
                                        <span>{{ item.name }}</span>
                                    </router-link>
                                </template>
                            </li>
                        </template>

                    </ul>
                </div>
                <button class="sidebar-toggler btn x"><i data-feather="x"></i></button>
            </div>
        </div>
        <vertical-header></vertical-header>
        <div id="main">
            <div style="min-height: 700px;">
                <router-view></router-view>
            </div>
            <the-footer></the-footer>
        </div>
    </div>
</template>
<script>
import TheSidebar from './TheSidebar'
import TheFooter from './TheFooter'
import VerticalHeader from './VerticalHeader'
import Auth from "../Auth";
import axios from "axios";

export default {
    name: 'TheContainer',
    components: {
        TheSidebar,
        TheFooter,
        VerticalHeader
    },
    created() {
        // this.updateCurrency(window.localStorage.getItem('currency'));
        this.closeSideBarMenu();
        this.checkPermissions();
    },
    watch: {
        '$route': 'checkPermissions'
    },
    mounted() {
        //lang
        if(window.localStorage.getItem('lang')){
            this.lang = window.localStorage.getItem('lang');
        }

        function slideToggle(t,e,o){0===t.clientHeight?j(t,e,o,!0):j(t,e,o)}function slideUp(t,e,o){j(t,e,o)}function slideDown(t,e,o){j(t,e,o,!0)}function j(t,e,o,i){void 0===e&&(e=400),void 0===i&&(i=!1),t.style.overflow="hidden",i&&(t.style.display="block");var p,l=window.getComputedStyle(t),n=parseFloat(l.getPropertyValue("height")),a=parseFloat(l.getPropertyValue("padding-top")),s=parseFloat(l.getPropertyValue("padding-bottom")),r=parseFloat(l.getPropertyValue("margin-top")),d=parseFloat(l.getPropertyValue("margin-bottom")),g=n/e,y=a/e,m=s/e,u=r/e,h=d/e;window.requestAnimationFrame(function l(x){void 0===p&&(p=x);var f=x-p;i?(t.style.height=g*f+"px",t.style.paddingTop=y*f+"px",t.style.paddingBottom=m*f+"px",t.style.marginTop=u*f+"px",t.style.marginBottom=h*f+"px"):(t.style.height=n-g*f+"px",t.style.paddingTop=a-y*f+"px",t.style.paddingBottom=s-m*f+"px",t.style.marginTop=r-u*f+"px",t.style.marginBottom=d-h*f+"px"),f>=e?(t.style.height="",t.style.paddingTop="",t.style.paddingBottom="",t.style.marginTop="",t.style.marginBottom="",t.style.overflow="",i||(t.style.display="none"),"function"==typeof o&&o()):window.requestAnimationFrame(l)})}
        let sidebarItems = document.querySelectorAll('.sidebar-item.has-sub');
        for(var i = 0; i < sidebarItems.length; i++) {
            let sidebarItem = sidebarItems[i];
            sidebarItems[i].querySelector('.sidebar-link').addEventListener('click', function(e) {
                e.preventDefault();

                let submenu = sidebarItem.querySelector('.submenu');
                if( submenu?.classList?.contains('active') ) submenu.style.display = "block"
                if( submenu.style.display == "none" ) submenu?.classList?.add('active')
                else submenu?.classList?.remove('active')
                slideToggle(submenu, 300)
            })
        }
        window.addEventListener('DOMContentLoaded', (event) => {
            var w = window.innerWidth;
            if(w < 1200) {
                document.getElementById('sidebar')?.classList?.remove('active');
            }
        });
        window.addEventListener('resize', (event) => {
            var w = window.innerWidth;
            if(w < 1200) {
                document.getElementById('sidebar')?.classList?.remove('active');
            }else{
                document.getElementById('sidebar')?.classList?.add('active');
            }
        });
        document.querySelector('.burger-btn').addEventListener('click', () => {
            document.getElementById('sidebar')?.classList?.toggle('active');
        })
        document.querySelector('.sidebar-hide').addEventListener('click', () => {
            document.getElementById('sidebar')?.classList?.toggle('active');
        })
        // Perfect Scrollbar Init
        if(typeof PerfectScrollbar.default == 'function') {
            const container = document.querySelector(".sidebar-wrapper");
            const ps = new PerfectScrollbar.default(container, {
                wheelPropagation: false
            });
        }

        // Scroll into active sidebar
        if(document.querySelector('.sidebar-item.active')){
            document.querySelector('.sidebar-item.active').scrollIntoView(false)
        }


    },
    data: function() {
        return {
            lang: 'en',
            search: '',
            sidebarItems :[
                {
                    name: __('dashboard'),
                    icon : 'dashboard',
                    url:'/dashboard',
                    permission:'manage_dashboard'
                },
                {
                    name: __('orders'),
                    icon :'shopping-cart',
                    url:'/orders',
                    permission:'order_list'
                },
                {
                    name: __('categories'),
                    icon : 'bullseye',
                    permission:'category_list',
                    submenu:[
                        {
                            name: __('add_category'),
                            icon : 'grid-fill',
                            url:'/manage_categories/create'
                        },
                        {
                            name: __('manage_categories'),
                            icon : 'grid-fill',
                            url:'/manage_categories'
                        },
                        {
                            name: __('order_categories'),
                            icon : 'grid-fill',
                            url:'/categories_order'
                        },
                    ]
                },
                {
                    name: __('products'),
                    icon : 'cubes',
                    permission:'product_list',
                    submenu:[
                        {
                            name: __('add_product'),
                            icon : 'grid-fill',
                            url:'/manage_products/create'
                        },
                        {
                            name: __('manage_products'),
                            icon : 'grid-fill',
                            url:'/manage_products'
                        },
                        {
                            name: __('units'),
                            icon : 'grid-fill',
                            url:'/units',
                            permission:'manage_units',
                        },
                        {
                            name: __('media'),
                            icon : 'grid-fill',
                            url:'/media'
                        },
                        {
                            name: __('bulk_upload'),
                            icon : 'grid-fill',
                            url:'/bulk_upload'
                        },
                        {
                            name: __('taxes'),
                            icon : 'grid-fill',
                            url:'/taxes'
                        },
                        {
                            name: __('brands'),
                            icon : 'grid-fill',
                            url:'/brands'
                        },
                        {
                            name: __('product_order'),
                            icon : 'grid-fill',
                            url:'/product_order'
                        },
                    ]
                },
                {
                    name: __('sellers'),
                    icon: 'male',
                    permission:'seller_list',
                    submenu: [
                        {
                            name: __('add_seller'),
                            icon : 'grid-fill',
                            url:'/sellers/create'
                        },
                        {
                            name: __('seller_requests'),
                            icon : 'grid-fill',
                            url:'/registered_sellers'
                        },
                        {
                            name: __('manage_sellers'),
                            icon : 'grid-fill',
                            url:'/sellers'
                        },
                        {
                            name: __('seller_commissions'),
                            icon : 'grid-fill',
                            url:'/seller_commissions'
                        },
                        {
                            name: __('seller_wallet_transactions'),
                            icon : 'grid-fill',
                            url:'/seller_wallet_transactions'
                        },
                        {
                            name: __('policies_seller'),
                            icon : 'grid-fill',
                            url:'/privacy_policy_seller',
                            permission:'manage_privacy_policy_seller_app',
                        },
                    ],
                },
                {
                    name: __('home_sliders'),
                    icon : 'picture-o',
                    permission:'home_slider_image_list',
                    submenu: [
                        {
                            name: __('add_home_slider'),
                            icon : 'grid-fill',
                            url:'/home_sliders/create',
                        },
                        {
                            name: __('manager_home_sliders'),
                            icon : 'grid-fill',
                            url:'/home_sliders',
                        }
                    ]
                },
                {
                    name: __('offer_image'),
                    icon : 'gift',
                    permission:'new_offer_image_list',
                    submenu: [
                        {
                            name: __('add_offer_image'),
                            icon : 'grid-fill',
                            url:'/offers/create',
                        },
                        {
                            name: __('manage_offer_images'),
                            icon : 'grid-fill',
                            url:'/offers',
                        },
                        {
                            name: __('manage_popup_offer'),
                            icon : 'grid-fill',
                            url:'/popup',
                        }
                    ]
                },

                {
                    name: __('promo_code'),
                    icon : 'gift',
                    permission:'promo_code_list',
                    submenu: [
                        {
                            name: __('add_promo_code'),
                            icon : 'grid-fill',
                            url:'/promo_code/create',
                        },
                        {
                            name: __('manage_promo_code'),
                            icon : 'grid-fill',
                            url:'/promo_code',
                        }
                    ]

                },

                {
                    name: __('featured_sections'),
                    icon : 'puzzle-piece',
                    permission:'featured_section_list',
                    submenu: [
                        {
                            name: __('add_section'),
                            icon : 'grid-fill',
                            url:'/sections/create',
                        },
                        {
                            name: __('manage_section'),
                            icon : 'grid-fill',
                            url:'/sections',
                        },
                        {
                            name: __('order_section'),
                            icon : 'grid-fill',
                            url:'/section_order',
                        },
                    ]

                },

                {
                    name: __('return_requests'),
                    icon : 'retweet',
                    url:'/return_requests',
                    permission:'return_request_list',
                },
                {
                    name: __('withdrawal_requests'),
                    icon : 'credit-card',
                    url:'/withdrawal_requests',
                    permission:'withdrawal_request_list',
                },
                {
                    name: __('delivery_boys'),
                    icon : 'male',
                    permission:'delivery_boy_list',
                    submenu: [
                        {
                            name: __('add_delivery_boy'),
                            icon : 'grid-fill',
                            url:'/delivery_boys/create'
                        },
                        {
                            name: __('dlivery_boy_requests'),
                            icon : 'grid-fill',
                            url:'/registered_delivery_boys'
                        },
                        {
                            name: __('manage_delivery_boys'),
                            icon : 'grid-fill',
                            url:'/delivery_boys'
                        },
                        {
                            name: __('fund_transfers'),
                            icon : 'grid-fill',
                            url:'/fund_transfers'
                        },
                        {
                            name: __('delivery_boy_cash'),
                            icon : 'grid-fill',
                            url:'/cash_collection'
                        },
                        {
                            name: __('delivery_boy_policies'),
                            icon : 'grid-fill',
                            url:'/privacy_policy_delivery_boy',
                            permission:'manage_privacy_policy_delivery_boy',
                        },
                    ]
                },
                {
                    name: __('notifications'),
                    icon : 'share-square-o',
                    url:'/notifications',
                    permission:'notification_list',
                    submenu: [
                        {
                            name: __('send_notifications'),
                            icon : 'grid-fill',
                            url:'/notifications/create'
                        },{
                            name: __('manage_notifications'),
                            icon : 'grid-fill',
                            url:'/notifications'
                        },{
                            name: __('notifications_settings'),
                            icon : 'grid-fill',
                            url:'/notification_settings',
                            permission:'manage_Notification_settings',
                        }
                    ]
                },

                {
                    name: __('system'),
                    icon: 'wrench',
                    permission:'manage_time_slots',
                    submenu: [
                        {
                            name: __('store_settings'),
                            icon : 'grid-fill',
                            url:'/store_settings',
                            permission:'manage_store_settings',
                        },
                        {
                            name: __('time_slots'),
                            icon : 'grid-fill',
                            url:'/time_slots',
                            permission:'manage_time_slots',
                        },
                        {
                            name: __('payment_methods'),
                            icon : 'grid-fill',
                            url:'/payment_methods',
                            permission:'manage_payment_methods',
                        },
                        {
                            name: __('contact_us'),
                            icon : 'grid-fill',
                            url:'/contact_us',
                            permission:'manage_contact_us',
                        },
                        {
                            name: __('about_us'),
                            icon : 'grid-fill',
                            url:'/about_us',
                            permission:'manage_about_us',
                        },
                        /*{
                            name: __('privacy_policy_manager_app'),
                            icon : 'grid-fill',
                            url:'/privacy_policy_manager_app',
                            permission:'manage_privacy_policy_manager_app',
                        },*/

                        /*{
                            name: __('secret_key'),
                            icon : 'grid-fill',
                            url:'/api_key',
                            permission:'manage_secret_key',
                        },*/

                        /*{
                            name: __('shipping_methods'),
                            icon : 'grid-fill',
                            url:'/shipping_methods'
                        },*/
                        {
                            name: __('firebase_setup'),
                            icon : 'grid-fill',
                            url:'/firebase',
                            permission:'manage_secret_key',
                        },
                        {
                            name: __('system_registration'),
                            icon : 'grid-fill',
                            url:'/purchase_code'
                        },
                    ],
                },



                {
                    name: __('web_settings'),
                    // icon : 'gear fa-spin',
                    icon : 'gear',
                    permission:'general_settings',
                    submenu: [
                        {
                            name:  __('general_web_settings'),
                            icon : 'grid-fill',
                            url:'/general_settings',
                            permission:'general_settings',
                        },
                        {
                            name: __('social_media'),
                            icon : 'grid-fill',
                            url:'/social_media',
                            permission:'manage_social_media_list',
                        },
                        /*{
                            name: __('about'),
                            icon : 'grid-fill',
                            url:'/front_end_about',
                            permission:'manage_about',
                        },
                        {
                            name: __('policies'),
                            icon : 'grid-fill',
                            url:'/front_end_policies',
                            permission:'manage_policies',
                        },*/
                    ]
                },

                {
                    name:__('languages'),
                    icon: 'language',
                    permission:'city_list',
                    submenu: [
                        {
                            name: __('add_language'),
                            icon: 'grid-fill',
                            url: '/languages/create',
                            permission:'manage_dashboard',
                        },
                        {
                            name: __('manage_languages'),
                            icon: 'grid-fill',
                            url: '/languages',
                            permission:'manage_dashboard',
                        }
                    ]
                },

                {
                    name: __('location'),
                    icon : 'map-o',
                    permission:'city_list',
                    submenu: [
                        {
                            name: __('add_city'),
                            icon: 'grid-fill',
                            url: '/cities/create',
                            permission:'manage_dashboard',
                        },

                        {
                            name: __('manage_cities'),
                            icon: 'grid-fill',
                            url: '/cities',
                            permission:'manage_dashboard',
                        }
                        /*,
                        {
                            name: __('deliverable_area'),
                            icon: 'grid-fill',
                            url: '/deliverable_area',
                            permission:'manage_dashboard',
                        }*/
                    ]
                },
                {
                    name: __('customers'),
                    icon : 'male',
                    permission:'customer_list',
                    submenu: [
                        {
                            name: __('customers'),
                            icon : 'grid-fill',
                            url:'/users',
                            permission:'customer_list',
                        },
                        {
                            name: __('wishlists'),
                            icon : 'grid-fill',
                            url:'/wishlists',
                            permission:'manage_wishlists',
                        },
                        {
                            name: __('transactions'),
                            icon : 'grid-fill',
                            url:'/transactions',
                            permission:'transaction_list',
                        },
                        {
                            name: __('customer_policies'),
                            icon : 'grid-fill',
                            url:'/privacy_policy',
                            permission:'manage_privacy_policy',
                        },
                        /*{
                            name: __('manage_customer_wallet'),
                            icon : 'grid-fill',
                            url:'/wallet_transactions',
                            permission:'manage_customer_wallet',
                        },*/
                    ]
                },
                /*{
                    name: __('newsletter'),
                    icon : 'newspaper-o',
                    url:'/newsletter',
                    permission:'featured_section_list',
                },*/
                {
                    name: __('reports'),
                    icon : 'folder-open',
                    permission:'product_sales_reports',
                    submenu: [
                        {
                            name: __('product_sales_report'),
                            icon: 'grid-fill',
                            url: '/product_sales_reports',
                            permission:'product_sales_reports',
                        },
                        {
                            name: __('sales_reports'),
                            icon: 'grid-fill',
                            url: '/sales_reports',
                            permission:'sales_reports',
                        }
                    ]
                },
                {
                    name: __('system_users'),
                    icon : 'users',
                    url:'/system_users',
                    role : true
                },
                {
                    name:__('role'),
                    icon : 'user-secret',
                    url:'/role',
                    role : true
                },
                {
                    name:__('faqs'),
                    icon : 'info',
                    url:'/faqs',
                    permission:'faq_list',
                },

            ]

        }
    },
    computed: {
        filteredSidebarItems() {
            //return this.filterItem(this.sidebarItems);
            //console.log("filteredSidebarItems : ",this.sidebarItems);
            return this.sidebarItems;
        }
    },
    methods: {

        filterItem(){

            var filter = this.search;
            $(`.sidebar-menu li:not(.sidebar-search)`).each(function (index, element) {
                const item = $(element);
                const parentListIsNested = item.closest('ul').hasClass('submenu');

                if (item.text().match(new RegExp(filter, 'gi'))) {
                    item.fadeIn();
                    if (parentListIsNested){
                        item.closest('ul').removeClass('active');
                    }
                } else {
                    item.fadeOut();
                    if (parentListIsNested){
                        item.closest('ul').addClass('active');
                    }
                }
            });
        },
        subIsActive(item) {
            const paths = Array.isArray(item.submenu) ? item.submenu : [];
            return paths.some(path => {
                return this.$route.path.indexOf(path.url) === 0;
            });
        },
        isActive(url) {
            if(this.$route.path == url){
                return true;
            }
            return false;
        },
        isHasSub(item){
            if(item.hasOwnProperty("submenu")){
                if(item.submenu.length > 0){
                    return true;
                }
            }
            return false;
        },
        changeLanguage(event){
            /*console.log(event.target.value)
            console.log('changeLanguage');*/
            this.lang = event.target.value;
            window.localStorage.setItem('lang', this.lang);
            this.isLoading = true
            let data = {
                language : this.lang
            }
            axios.post(this.$apiUrl + '/change_language',data)
                .then((response) => {
                    this.isLoading = false;
                    window.location.reload();
                });
        },

        checkPermissions() {
            //console.log(this.$route.path)
            var current_path = this.$route.path;
            var permission = '';

            // console.log("checkPermissions : ",this.sidebarItems);
            // console.log("checkPermissions 2 : ",window.i18n);

            this.sidebarItems.forEach(menu => {
                //Only Main Categories
                if(menu.submenu && menu.submenu.length>0) {
                    menu.submenu.forEach(submenu => {
                        if(submenu.url === current_path){
                            permission = submenu.permission;
                        }
                    });
                }else{
                    if(menu.url === current_path){
                        permission = menu.permission;
                    }
                }
            });

            if(Auth.check() && UserPermissions.length === 0){
                //this.$router.push({path:'/login'});
                if(window.localStorage.getItem('loginCheck') == 1){
                    Auth.logout();
                }
                window.localStorage.setItem('loginCheck',1);
                window.location.reload();
            }else if(Auth.check() && permission && !this.$can(permission)){
                this.$router.push({path:'/unauthorized'});
            }

        },

        closeSideBarMenu() {
            var w = window.innerWidth;
            if(w < 1200) {
                document.getElementById('sidebar')?.classList?.remove('active');
            }
        }
    }
}
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.3s;
}
.fade-enter,
.fade-leave-to {
    opacity: 0;
}
</style>
