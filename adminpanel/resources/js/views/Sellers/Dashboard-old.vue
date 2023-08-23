<template>
    <div>
        <div class="page-heading">
            <h3>{{ __('dashboard') }}</h3>
        </div>
        <div class="page-content">
            <section class="row">
                <div class="col-12 col-lg-12">
                    <div class="row">
                        <div class="col-6 col-lg-3 col-md-6">
                            <router-link to="/orders">
                                <div class="card">
                                    <div class="card-body px-3 py-4-5">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="stats-icon purple">
                                                    <i class="iconly-boldBag"></i>
                                                </div>
                                            </div>
                                            <div class="col-md-8">
                                                <h6 class="text-muted font-semibold">{{ __('orders') }}</h6>
                                                <h6 class="font-extrabold mb-0">{{ record.order_count }}</h6>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </router-link>
                        </div>

                        <div class="col-6 col-lg-3 col-md-6">
                            <router-link to="/manage_products">
                                <div class="card">
                                    <div class="card-body px-3 py-4-5">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="stats-icon blue">
                                                    <i class="iconly-boldProfile"></i>
                                                </div>
                                            </div>
                                            <div class="col-md-8">
                                                <h6 class="text-muted font-semibold">{{ __('products') }}</h6>
                                                <h6 class="font-extrabold mb-0">{{ record.product_count }}</h6>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </router-link>
                        </div>


                    </div>


                </div>

                <div class="row">
                    <div class="col-6">
                        <div class="card">
                            <div class="card-content">
                                <div class="card-body">
                                    {{ record.sold_out_count+' '+__('products_sold_out')}}
                                </div>
                            </div>
                            <div class="card-footer d-flex justify-content-between">
                                <!--<router-link to="/sold_out_products" class="btn btn-light-primary">More Info</router-link>-->
                                <router-link :to="{ name: 'ProductInfo',params: { type: 'sold_out' }}"
                                             class="btn btn-light-primary">{{ __('more_info')}}
                                </router-link>
                            </div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="card">
                            <div class="card-content">
                                <div class="card-body">
                                    {{ record.low_stock_count+' '+__('products_in_low_stock') }}
                                </div>
                            </div>
                            <div class="card-footer d-flex justify-content-between">
                                <router-link :to="{ name: 'ProductInfo',params: { type: 'low_stock' }}"
                                             class="btn btn-light-primary">More Info
                                </router-link>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">

                    <div class="col-6">
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">{{__('weekly_sales')}}</h4>
                                <p>{{__('total_sale_in_last_week')}} ({{__('month')}}: {{ currentMonth }})</p>
                            </div>
                            <div class="card-body">
                                <!--                                v-if="graphOrders.length !== 0"-->
                                <apexchart width="500" type="bar" :options="options" :series="series" ref="apexBarChart"></apexchart>
                            </div>
                        </div>
                    </div>

                    <div class="col-6">
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">{{__('product_category_count')}}</h4>
                            </div>
                            <div class="card-body">
                                <apexcharts width="500" height="350" type="pie" :options="options2" :series="series2"></apexcharts>
                            </div>
                        </div>
                    </div>
                </div>

            </section>
        </div>
    </div>
</template>
<script>
import axios from "axios";
import {GChart} from 'vue-google-charts/legacy';
import moment from "moment";

import VueApexCharts from 'vue-apexcharts'

export default {
    name: 'Chart',
    components: {
        GChart,
        apexcharts: VueApexCharts,
    },
    data: function () {
        return {
            isLoading: false,
            record: [],
            currentMonth: "",

            sellerFields: [
                {key: 'seller_id', label: __('id'), sortable: true, sortDirection: 'desc'},
                {key: 'seller_name', label: __('sellers'), sortable: true, class: 'text-center'},
                {key: 'store_name', label: __('store_name'), sortable: true, class: 'text-center'},
                {key: 'total_revenue', label: __('total_revenue'), sortable: true, class: 'text-center'},
                {key: "actions", label: __('actions')}
            ],

            categoryFields: [
                {key: 'category_id', label: __('id'), sortable: true, sortDirection: 'desc'},
                {key: 'category_name', label: __('category'), sortable: true, class: 'text-center'},
                {key: 'product_name', label: __('product'), sortable: true, class: 'text-center'},
                {key: 'total_revenue', label:  __('total_revenue'), sortable: true, class: 'text-center'},
                {key: "actions", label: __('actions')}
            ],

            orderFields: [
                {key: 'id', label: __('oid'), sortable: true, sortDirection: 'desc'},
                {key: 'user_name', label: __('user'), sortable: true, class: 'text-center'},
                {key: 'mobile', label: __('mobile'), sortable: true, class: 'text-center'},
                {key: 'total', label: __('total'), sortable: true, class: 'text-center'},
                {key: 'delivery_charge', label: __('dcharges'), sortable: true, class: 'text-center'},
                {key: 'tax', label: __('tax_per'), sortable: true, class: 'text-center'},
                {key: 'discount', label: __('disc_per'), sortable: true, class: 'text-center'},
                {key: 'promo_discount', label: __('promo_disc_per'), sortable: true, class: 'text-center'},
                {key: 'wallet_balance', label: __('wallet_used'), sortable: true, class: 'text-center'},
                {key: 'final_total', label: __('ftotal'), sortable: true, class: 'text-center'},
                {key: 'payment_method', label: __('p_method'), sortable: true, class: 'text-center'},
                {key: 'delivery_time', label: __('d_time'), sortable: true, class: 'text-center'},
                {key: "actions", label: __('actions')}
            ],

            pageOptions: this.$pageOptions,
            sortBy: '',
            sortDesc: false,
            sortDirection: 'asc',
            filter: null,
            filterOn: [],
            page: 1,

            sectionStyle: 'style_1',
            max_visible_units: 12,
            max_col_in_single_row: 3,

            sellers: [],
            totalRows: 1,
            currentPage: 1,
            perPage: this.$perPage,

            categories: [],
            categoryTotalRows: 1,
            categoryCurrentPage: 1,
            categoryPerPage: this.$perPage,

            statuses: [],
            orders: [],
            orderTotalRows: 1,
            orderCurrentPage: 1,
            orderPerPage: this.$perPage,
            status: "",
            filterSellers: "",
            seller: "",

            graphOrders: [],
            isLoadingColumnChart: false,
            graphCategories: [],

            chartData:[],

            options: {
                chart: {
                    height: 350,
                    type: 'bar',
                },
                plotOptions: {
                    bar: {
                        borderRadius: 2,
                        dataLabels: {
                            position: 'top', // top, center, bottom
                        },
                    }
                },
                dataLabels: {
                    enabled: true,
                    offsetY: -20,
                    style: {
                        fontSize: '12px',
                        colors: ["#304758"]
                    }
                },

                xaxis: {
                    categories: [],
                    position: 'top',
                    axisBorder: {
                        show: false
                    },
                    axisTicks: {
                        show: false
                    },
                    crosshairs: {
                        fill: {
                            type: 'gradient',
                            gradient: {
                                /*colorFrom: '#D8E3F0',*/
                                colorFrom: '#000',
                                /*colorTo: '#BED1E6',*/
                                colorTo: '#000',
                                stops: [0, 100],
                                opacityFrom: 0.4,
                                opacityTo: 0.5,
                            }
                        }
                    },
                    tooltip: {
                        enabled: true,
                    }
                },
                yaxis: {
                    axisBorder: {
                        show: false
                    },
                    axisTicks: {
                        show: false,
                    },
                    labels: {
                        show: false,
                    }

                },
                title: {
                    text: 'Total Sale In Last Week.',
                    floating: true,
                    offsetY: 330,
                    align: 'center',
                    style: {
                        color: '#444'
                    }
                },
                noData: {
                    text: "No Data Found",
                    align: 'center',
                }
            },

            series: [{
                name: 'Total Sale',
                data: []
            }],

            options2: {
                chart: {
                    width: 380,
                    type: 'pie',
                },
                labels: [],
                responsive: [{
                    breakpoint: 480,
                    options: {
                        chart: {
                            width: 200
                        },
                        legend: {
                            position: 'bottom'
                        }
                    }
                }]
            },
            series2: []
        };
    },
    mounted() {
        // Set the initial number of items
        this.totalRows = this.sellers.length
        this.categoryTotalRows = this.categories.length
        this.orderTotalRows = this.orders.length
    },
    created() {

        this.barChart();
        this.pieChart();

        let months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
        let now = new Date();
        this.currentMonth = months[now.getMonth()];
        this.getRecord();
        this.getOrderStatus();
        this.getLatestOrders();
        //this.onColumnChartReady();
    },
    methods: {
        barChart(){
            axios.get(this.$sellerApiUrl + '/orders/weekly_sales').then((response) => {
                    this.graphOrders = response.data.data;
                    this.graphOrders.forEach((order) => {
                        this.options.xaxis.categories.push(moment(order.order_date).format('DD-MMM'));
                        this.series[0].data.push(order.total_sale);
                    });

                    this.$refs.apexBarChart.updateSeries([{
                        data: this.series[0].data,
                    }], false, true);
            })
        },
        pieChart(){
            axios.get(this.$sellerApiUrl + '/categories/product_count').then((response) => {
                    this.graphCategories = response.data.data;
                    this.graphCategories.forEach((category) => {
                        if(category.product_count !== 0){
                            this.options2.labels.push(category.name);
                            this.series2.push(category.product_count);
                        }
                    });
            })
        },

        /*onColumnChartReady(chart, google) {
            this.isLoadingColumnChart = true;
            axios.get(this.$apiUrl + '/orders/weekly_sales').then((response) => {
                this.graphOrders = response.data.data;
                this.chartData = [['Date', 'Total Sale In']];
                this.graphOrders.forEach((order) => {
                    this.chartData.push([moment(order.order_date).format('DD-MMM'), order.total_sale])
                });
                let data = google.visualization.arrayToDataTable(this.chartData);
                let view = new google.visualization.DataView(data);
                view.setColumns(
                    [0, 1,
                        {
                            calc: "stringify",
                            sourceColumn: 1,
                            type: "string",
                            role: "annotation"
                        }
                    ]);
                let columnChartOptions = {
                    chart: {
                        title: 'Weekly Sales',
                    }
                };
                this.isLoadingColumnChart = false;
                chart.draw(view, columnChartOptions);
            });
        },*/
        /*onPieChartReady(chart, google) {
            axios.get(this.$apiUrl + '/categories/product_count').then((response) => {
                this.graphCategories = response.data.data;
                let chartData = [['Product', 'Count']];
                this.graphCategories.forEach((category) => {
                    chartData.push([category.name, category.product_count])
                });
                let data = google.visualization.arrayToDataTable(chartData);
                let view = new google.visualization.DataView(data);
                view.setColumns([0, 1,
                    {
                        calc: "stringify",
                        sourceColumn: 1,
                        type: "string",
                        role: "annotation"
                    }
                ]);
                let columnChartOptions = {
                    chart: {
                        title: 'Weekly Sales',
                    },
                    is3D: true
                };
                chart.draw(view, columnChartOptions);
            });
        },*/


        getRecord: function () {
            let vm = this;
            this.isLoading = true;
            axios.get(this.$sellerApiUrl + '/dashboard').then(res => {
                vm.isLoading = false;
                let data = res.data;
                if (data.status === 1) {
                    this.record = data.data;
                }
            }).catch(error => {
                vm.isLoading = false;
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError("Something went wrong!");
                }
            });
        },
        getOrderStatus: function () {
            let vm = this;
            axios.get(this.$apiUrl + '/order_statuses').then((response) => {
                this.isLoading = false
                this.statuses = response.data.data;
                //console.log("this.statuses =>",this.statuses);
            }).catch(error => {
                vm.isLoading = false;
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError("Something went wrong!");
                }
            });
        },
        getLatestOrders: function () {
            this.isLoading = true;
            let vm = this;
            let param = {
                "seller": this.seller,
                "status": this.status,
                "shipping_type": this.shipping_type
            }
            axios.get(this.$apiUrl + '/orders', {
                params: param
            }).then((response) => {
                let data = response.data;
                if (data.status === 1) {
                    this.filterSellers = response.data.data.sellers;
                    this.orders = response.data.data.orders;
                    this.orderTotalRows = this.orders.length;
                    this.isLoading = false
                }
            }).catch(error => {
                vm.isLoading = false;
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError("Something went wrong!");
                }
            });
        },
        deleteOrder(index, id) {
            this.$swal.fire({
                title: "Are you Sure?",
                text: "You want be able to revert this",
                confirmButtonText: "Yes, Sure",
                cancelButtonText: "Cancel",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#37a279',
                cancelButtonColor: '#d33',
            }).then(result => {
                if (result.value) {
                    this.isLoading = true
                    let postData = {
                        id: id
                    }
                    axios.post(this.$apiUrl + '/orders/delete', postData)
                        .then((response) => {
                            this.isLoading = false
                            let data = response.data;
                            this.orders.splice(index, 1)
                            this.showSuccess(data.message)
                        });
                }
            });
        },
    },
};
</script>
