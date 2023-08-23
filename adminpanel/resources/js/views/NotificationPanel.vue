<template>
    <div>
        <div class="page-heading">
            <div class="page-title">
                <div class="row">
                    <div class="col-12 col-md-6 order-md-1 order-last">
                        <h3>Notification</h3>
                    </div>
                    <div class="col-12 col-md-6 order-md-2 order-first">
                        <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><router-link to="/dashboard">{{ __('dashboard') }}</router-link></li>
                                <li class="breadcrumb-item active" aria-current="page">Notification</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
            <section class="section">
                <div class="card">
                    <div class="card-header">
                        <h4 class="card-title">Notification Lists</h4>
                    </div>
                    <div class="card-body">
                        <b-row>
                            <b-col md="6" style="overflow-y:scroll;height:50vh;width: 100%">

                                <ul class="list-group">
                                    <li class="list-group-item" v-for="notification in notifications">
                                        <router-link :to="'/orders/view/'+notification.data.order_id">
                                            {{notification.data.text}}
                                        </router-link>
                                    </li>
                                    <infinite-loading @distance="1" @infinite="getNotifications">
                                        <span slot="no-more">
                                           There is no more notification.
                                        </span>
                                    </infinite-loading>
                                </ul>
                            </b-col>
                        </b-row>
                    </div>
                </div>
            </section>
        </div>
    </div>
</template>
<script>
import InfiniteLoading from 'vue-infinite-loading';
export default {
    components: {
        InfiniteLoading,
    },
    data: function() {
        return {
            isLoading: false,
            notifications: [],
            page: 1,
        }
    },
    computed: {

    },
    mounted() {

    },
    created: function() {
        this.getNotifications();
    },
    methods: {
        getNotifications($state){
            this.isLoading = true
            setTimeout(() => {
                let param = {
                    "page": this.page,
                }
                axios.get(this.$apiUrl + '/panel_notification', {
                    params: param
                }).then((response) => {
                    this.isLoading = false
                    let data = response.data.data.data;
                    if (data.length) {
                        data.forEach((value, key) => {
                            this.notifications.push(value);
                        });
                        $state.loaded();
                    }else{
                        $state.complete();
                    }
                    this.page = this.page + 1;
                });
            },1000);
        },
    }
};
</script>
