<template>
    <div>
        <div class="page-heading">
            <div class="page-title">
                <div class="row">
                    <div class="col-12 col-md-6 order-md-1 order-last">
                        <h3>Customers List</h3>
                    </div>
                    <div class="col-12 col-md-6 order-md-2 order-first">
                        <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><router-link to="/dashboard">{{ __('dashboard') }}</router-link></li>
                                <li class="breadcrumb-item active" aria-current="page">Customers List</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
            <section class="section">
                <div class="card">
                    <div class="card-header">
                        <h4 class="card-title">Customers</h4>
                    </div>
                    <div class="card-body">

                        <b-row class="mb-2">
                            <b-col md="3" offset-md="8">
                                <h6 class="box-title">Search</h6>
                                <b-form-input
                                    id="filter-input"
                                    v-model="filter"
                                    type="search"
                                    placeholder="Search"
                                    @click="addFilter()"
                                ></b-form-input>
                            </b-col>
                            <b-col md="1" class="text-center">
                                <button class="btn btn-primary btn_refresh" v-b-tooltip.hover :title="__('refresh')"
                                        @click="getCustomers()">
                                    <i class="fa fa-refresh" aria-hidden="true"></i>
                                </button>
                            </b-col>
                        </b-row>
                        <div class="table-responsive">
<!--                            {{ customers }}-->
                        <b-table
                            :items="customers"
                            :fields="fields"
                            :current-page="currentPage"
                            :per-page="perPage"
                            :filter="filter"
                            :filter-included-fields="filterOn"
                            :sort-by.sync="sortBy"
                            :sort-desc.sync="sortDesc"
                            :sort-direction="sortDirection"
                            :bordered="true"
                            :busy="isLoading"
                            stacked="md"
                            show-empty
                            small>
                            <template #table-busy>
                                <div class="text-center text-black my-2">
                                    <b-spinner class="align-middle"></b-spinner>
                                    <strong>{{ __('loading') }}...</strong>
                                </div>
                            </template>

                            <template #cell(email)="row">
                                {{ row.item.email | emailMask }}
                            </template>
                            <template #cell(mobile)="row">
                                {{ row.item.mobile | mobileMask }}
                            </template>

                            <template #cell(status)="row">
                                <span v-if="row.item.status == 1" class="badge bg-success">Active</span>
                                <span v-else class="badge bg-danger">Deactive</span>
                            </template>

                            <template #cell(created_at)="row">
                                {{ new Date(row.item.created_at).toLocaleString()  }}
                            </template>
                            <template #cell(actions)="row">
                                <a  class="btn btn-sm" @click="updateStatusCustomer(row.index,row.item.id)">
                                    <span class="primary-toggal" v-if="row.item.status == 1" ><i class="fa fa-toggle-on fa-2x"></i></span>
                                    <span class="text-danger" v-else><i class="fa fa-toggle-off fa-2x"></i></span>
                                </a>
<!--                                <button  class="btn btn-sm btn-danger" @click="updateStatusCustomer(row.index,row.item.id)">
                                    <i class="fa fa-toggle-off"></i>
                                </button>-->
<!--                                <div class="form-check form-switch">
                                    <input id="cod_payment_method" type="checkbox" class="form-check-input" v-on:change="updateStatusCustomer(row.index,row.item.id)" :checked="row.item.status == 1">
                                </div>-->
                            </template>

                        </b-table>
                        </div>
                        <b-row>
                            <b-col  md="2" class="my-1">
                                <label>
                                    <b-form-group
                                    :label="__('per_page')"
                                    label-for="per-page-select"
                                    label-align-sm="right"
                                    label-size="sm"
                                    class="mb-0">
                                    <b-form-select
                                        id="per-page-select"
                                        v-model="perPage"
                                        @change = "addFilter"
                                        :options="pageOptions"
                                        size="sm"
                                        class="form-control form-select"
                                    ></b-form-select>
                                </b-form-group>
                                </label>
                            </b-col>
                            <b-col  md="4" class="my-1" offset-md="6">
                                <label>Total Records:- {{ totalRows }}</label>
                                <b-pagination
                                    v-model="currentPage"
                                    :total-rows="totalRows"
                                    :per-page="perPage"
                                    align="fill"
                                    size="sm"
                                    class="my-0"
                                ></b-pagination>
                            </b-col>
                        </b-row>

                    </div>
                </div>
            </section>
        </div>


    </div>
</template>
<script>

export default {
    data: function() {
        return {
            isLoading: false,
            fields: [
                { key: 'id', label: 'ID', sortable: true, sortDirection: 'desc' },
                { key: 'name', label: 'Name', sortable: true, class: 'text-center' },
                { key: 'email', label: 'Email', sortable: true, class: 'text-center' },
                { key: 'mobile', label: 'M.No', sortable: true, class: 'text-center' },

                /*{ key: 'balance', label: 'Balance', sortable: true, class: 'text-center' },
                { key: 'friends_code', label: 'Friends code', sortable: true, class: 'text-center' },
                { key: 'city', label: 'City', sortable: true, class: 'text-center' },
                { key: 'pincode', label: 'Pincode', sortable: true, class: 'text-center' },*/

                { key: 'status', label: 'Status', sortable: true, class: 'text-center' },
                { key: 'created_at', label: 'Date & Time', sortable: true, class: 'text-center' },
                { key: 'actions', label: 'Action' }
            ],
            totalRows: 1,
            currentPage: 1,
            perPage: this.$perPage,
            pageOptions: this.$pageOptions,

            sortBy: 'id',
            sortDesc: true,
            sortDirection: 'desc',
            filter: null,
            filterOn: [],


            /*sectionStyle : 'style_1',
            max_visible_units : 12,
            max_col_in_single_row : 3,*/

            //create_new : null,
            //edit_record : null,

            customers: [],
        }
    },
    computed: {
        sortOptions() {
            // Create an options list from our fields
            return this.fields
                .filter(f => f.sortable)
                .map(f => {
                    return { text: f.label, value: f.key }
                })
        }
    },
    mounted() {
        // Set the initial number of items
        this.totalRows = this.customers.length
    },
    created: function() {
        this.$eventBus.$on('customersSaved', (message) => {
            this.showMessage("success", message);
            this.getCustomers();
            this.create_new = null;
        });
        this.getCustomers();
    },
    methods: {
        addFilter(){
            this.customers = [];
            this.totalRows = 1;
            this.currentPage = 1;
            this.offset = 0;
            this.getCustomers();
        },
        getCustomers(){
            let vm = this;
            this.isLoading = true;
            axios.get(this.$apiUrl + '/customers')
                .then((response) => {
                    this.isLoading = false;
                    vm.isLoading = false;

                    this.customers = response.data.data;

                    //this.totalRows = this.customers.length
                    this.totalRows = response.data.total;

                }).catch(error => {

                    vm.isLoading = false;
                    console.log("error => ", error);
                    if (error.request?.statusText) {
                        this.showError(error.request?.statusText);
                    }else if (error.message) {
                        this.showError(error.message);
                    } else {
                        this.showError(__('something_went_wrong'));
                    }
            });

            // alert("hello");

        },
        updateStatusCustomer(index, id){
            this.$swal.fire({
                title: "Are you Sure?",
                text: "You want to change status.",
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
                        id : id
                    }
                    axios.post(this.$apiUrl + '/customers/change',postData)
                        .then((response) => {
                            this.isLoading = false
                            //this.customers.splice(index, 1)
                            this.getCustomers();
                            //this.showSuccess(response.data.message);
                            this.showMessage("success", response.data.message);
                        });
                }
            });
        },

    }
};
</script>
