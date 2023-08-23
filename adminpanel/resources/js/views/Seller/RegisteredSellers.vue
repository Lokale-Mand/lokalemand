<template>
    <div>
        <div class="page-heading">
            <div class="row">
            <div class="col-12 col-md-6 order-md-1 order-last">
                <h3>New Registered Sellers</h3>
            </div>
            <div class="col-12 col-md-6 order-md-2 order-first">
                <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><router-link to="/dashboard">{{ __('dashboard') }}</router-link></li>
                        <li class="breadcrumb-item active" aria-current="page">New Registered Sellers</li>
                    </ol>
                </nav>
            </div>
        </div>
            <div class="row">
                <div class="col-12 col-md-12 order-md-1 order-last">
                    <div class="card">
                        <div class="card-header">
                            <h4>New Sellers List</h4>
                        </div>
                        <div class="card-body">
                            <b-row class="mb-2">
<!--                                <b-col md="3">

                                    <div class="form-group">
                                        <h6 for="filterStatus">Filter Seller by Status </h6>
                                        <select id="filterStatus" name="filterStatus" v-model="filterStatus" @change="getRecords()" class="form-control form-select">
                                            <option value="">All</option>
                                            <option value="0">Registered</option>
                                            <option value="1">Approved</option>
                                            <option value="2">Not-Approved</option>
                                            <option value="3">Deactivate</option>
                                            <option value="7">Removed</option>
                                        </select>
                                    </div>
                                </b-col>-->
                                <b-col md="3" offset-md="8">
                                    <h6 class="box-title">{{ __('search') }}</h6>
                                    <b-form-input
                                        id="filter-input"
                                        v-model="filter"
                                        type="search"
                                        :placeholder="__('search')"
                                    ></b-form-input>
                                </b-col>
                                <b-col md="1" class="text-center">
                                    <button class="btn btn-primary btn_refresh" v-b-tooltip.hover :title="__('refresh')" @click="getRecords()">
                                        <i class="fa fa-refresh" aria-hidden="true"></i>
                                    </button>
                                </b-col>
                            </b-row>
                            <b-row class="table-responsive">
                            <b-table
                                :items="records"
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

                                <template #cell(logo)="row">
                                    <span v-if="!row.item.logo">No Image</span>
                                    <img v-else :src="$storageUrl + row.item.logo" height="50" />
                                </template>
                                <template #cell(catWiseEditCommission)="row">
                                    <button class="btn btn-sm btn-primary" @click="edit_record = row.item" v-if="$can('seller_update')"><i class="fa fa-edit"></i></button>
                                </template>

                                <template #cell(status)="row">
                                    <label v-if="row.item.status == 0" class='badge bg-primary'>Registered</label>
                                    <label v-else-if="row.item.status == 1" class='badge bg-success'>Approved</label>
                                    <label v-else-if="row.item.status == 2" class='badge bg-warning'>Reject</label>
                                    <label v-else-if="row.item.status == 3" class='badge bg-danger'>Deactive</label>
                                    <label v-else-if="row.item.status == 7" class='badge bg-danger'>Removed</label>
                                </template>

                                <template #cell(require_products_approval)="row">
                                    <label v-if="row.item.require_products_approval == 1" class='badge bg-success'>Yes</label>
                                    <label v-else-if="row.item.require_products_approval == 0" class='badge bg-danger'>No</label>
                                </template>
                                <template #cell(actions)="row">

                                    <button class="btn btn-sm btn-success"
                                            type="button"
                                            @click="updateStatus(row.index,row.item.id, 1)" v-if="$can('seller_delete')" v-b-tooltip.hover title="Change Status">
                                        Approved
                                    </button>
                                    <button class="btn btn-sm btn-danger"
                                            type="button"
                                            @click="updateStatus(row.index,row.item.id, 2)" v-if="$can('seller_delete')" v-b-tooltip.hover title="Change Status">
                                        Reject
                                    </button>

<!--                                    <router-link :to="{ name: 'EditSeller',params: { id: row.item.id, record : row.item }}" v-b-tooltip.hover title="Edit" class="btn btn-primary btn-sm" v-if="$can('seller_update')" v-b-tooltip.hover :title="__('edit')">
                                        <i class="fa fa-pencil"></i>
                                    </router-link>
                                    <button class="btn btn-sm btn-danger" @click="deleteSeller(row.index,row.item.id)" v-if="$can('seller_delete')" v-b-tooltip.hover :title="__('delete')">
                                        <i class="fa fa-trash"></i>
                                    </button>-->
                                </template>

                            </b-table>
                            </b-row>

                            <b-row>
                                <b-col  md="2" class="my-1">
                                    <b-form-group
                                        :label="__('per_page')"
                                        label-for="per-page-select"
                                        label-align-sm="right"
                                        label-size="sm"
                                        class="mb-0">
                                        <b-form-select
                                            id="per-page-select"
                                            v-model="perPage"
                                            :options="pageOptions"
                                            size="sm"
                                            class="form-control form-select"
                                        ></b-form-select>
                                    </b-form-group>
                                </b-col>
                                <b-col  md="4" class="my-1" offset-md="6">
                                    <label>Total Records :- {{ totalRows }} </label>
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
                </div>
            </div>
        </div>
        <!-- Add / Edit -->
        <app-edit-record
            v-if="edit_record"
            :record="edit_record"
            @modalClose="hideModal()"
        ></app-edit-record>
    </div>
</template>
<script>
import EditRecord from './Commissions/Edit.vue';
export default {
    components: {
        'app-edit-record' : EditRecord,
    },
    data: function() {
        return {
            fields: [
                { key: 'id', label: 'ID', sortable: true, sortDirection: 'desc' },
                { key: 'name', label: 'Name', class: 'text-center', sortable: true, sortDirection: 'desc' },
                { key: 'store_name', label: 'Store Name', class: 'text-center', sortable: true, sortDirection: 'desc' },
                { key: 'email', label: 'Email', class: 'text-center', sortable: true, sortDirection: 'desc' },
                { key: 'mobile', label: 'Mobile No.', class: 'text-center', sortable: true, sortDirection: 'desc' },
                { key: 'logo', label: 'Logo', class: 'text-center', sortable: true, sortDirection: 'desc' },
                { key: 'status', label: 'Status', class: 'text-center', sortable: true, sortDirection: 'desc' },
                { key: 'require_products_approval', label: 'Pr. Approved?', class: 'text-center', sortable: true, sortDirection: 'desc' },
                { key: 'actions', label: 'Action' }
            ],
            totalRows: 1,
            currentPage: 1,
            perPage: this.$perPage,
            pageOptions: this.$pageOptions,
            sortBy: '',
            sortDesc: false,
            sortDirection: 'asc',
            filter: null,
            filterOn: [],
            page: 1,

            isLoading: false,
            sectionStyle : 'style_1',
            max_visible_units : 12,
            max_col_in_single_row : 3,
            records: [],
            edit_record : null,

            filterStatus : 0,
        }
    },
    created: function() {
        this.category_id = this.$route.params.id;
        this.$eventBus.$on('recordSaved', (message) => {
            this.showMessage('success', message);
            this.getRecords();
        });
        this.$eventBus.$on('commissionsSaved', (message) => {
            this.showMessage('success', message);
            this.getRecords();
        });
        this.getRecords();
    },
    methods: {
        getRecords(){
            this.isLoading = true;
            axios.get(this.$apiUrl + '/sellers', {
                params: {
                        filterStatus: this.filterStatus
                }
            }).then((response) => {
                    this.isLoading = false
                    let data = response.data;
                    this.records = data.data
                });
        },


       updateStatus(index, id, selectedStatus){
            this.$swal.fire({
                title: "Are you Sure?",
                text: "You want be able to revert this",
                confirmButtonText: "Yes, Sure",
                cancelButtonText: "Cancel",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#37a279',
                cancelButtonColor: '#d33',
            }).then(async result => {
                if (result.value) {
                    let remarks = "";
                    if (selectedStatus === 2) {
                        const {value: text} = await this.$swal.fire({
                            title: 'Remarks',
                            input: 'textarea',
                            /*inputLabel: 'Remarks',*/
                            inputPlaceholder: 'Type your remarks here...',
                            inputAttributes: {
                                'aria-label': 'Type your remarks here'
                            },
                            confirmButtonText: "Submit",
                            cancelButtonText: "Cancel",
                            showCancelButton: true,

                            inputValidator: (value) => {
                                return new Promise((resolve) => {
                                    if (value !== '') {
                                        resolve()
                                    } else {
                                        resolve('The Remarks field is required')
                                    }
                                })
                            }
                        })
                        if (text) {
                            remarks = text;
                        }
                    }
                    if (selectedStatus === 1 || (selectedStatus === 2 && remarks !== "") ){
                        this.isLoading = true
                        let postData = {
                            id : id,
                            status: selectedStatus,
                            remark : remarks
                        }
                        //console.log("postData =>", postData);
                        axios.post(this.$apiUrl + '/sellers/update-status',postData)
                            .then((response) => {
                                this.isLoading = false
                                let data = response.data;
                                //this.records.splice(index, 1)
                                this.getRecords();
                                //this.showSuccess(data.message)
                                this.showMessage('success', data.message);
                            });
                    }
                }
            });
        },

        deleteSeller(index, id){
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
                        id : id
                    }
                    axios.post(this.$apiUrl + '/sellers/delete',postData)
                        .then((response) => {
                            this.isLoading = false
                            let data = response.data;
                            this.records.splice(index, 1)
                            this.showSuccess(data.message)
                        });
                }
            });
        },
        updateSellerCommission(){
            this.$swal.fire({
                title: "Are you sure you want to credit seller commission?",
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
                    axios.get(this.$apiUrl + '/sellers/updateCommission')
                        .then((response) => {
                            let data = response.data;
                            if (data.status === 1) {
                                this.showSuccess(data.message)
                            }else{
                                this.showError(data.message);
                            }
                            this.isLoading = false
                        });
                }
            });
        },
        hideModal() {
            this.edit_record = false
        },
    }
};
</script>
