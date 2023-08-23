<template>

    <div>

        <div class="page-heading">
            <div class="row">
                <div class="col-12 col-md-6 order-md-1 order-last">
                    <h3>Manage Home Slider Images</h3>
                </div>
                <div class="col-12 col-md-6 order-md-2 order-first">
                    <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <router-link to="/dashboard">Dashboard</router-link>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Manage Home Slider Images</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <div class="row">
                <div class="col-12 col-md-12 order-md-1 order-last">
                    <div class="card">

                        <div class="card-header">
                            <h4>Home Slider Image</h4>
                            <span class="pull-right">
                                <button class="btn btn-primary" @click="create_new=true" v-if="$can('home_slider_image_create')">Add New</button>
                            </span>
                        </div>

                        <div class="card-body">
                            <!-- <div class="box-body">
                                <div class="form-group">
                                    <label>Section Style</label>
                                    <select class="form-control" v-model="sectionStyle">
                                        <option value="style_1">Style 1</option>
                                        <option value="style_2">Style 2</option>
                                    </select>
                                    <br>
                                </div>
                                <div class="form-group">
                                    <label>Maximum Number of Visible Categories in Home Page</label>
                                    <input type="number" class="form-control" v-model="max_visible_categories">
                                </div>
                                <div class="form-group" v-if="sectionStyle=='style_1'">
                                    <label>Maximum Columns in Single Row in Home Page</label>
                                    <input type="number" class="form-control" v-model="max_col_in_single_row">
                                </div>
                                <div class="box-footer">
                                    <button type="submit" class="btn btn-primary" @click="addCategorySettings">Add</button>
                                </div>
                            </div> -->


                            <!--                            <datatable :columns="columns" :data="categories" class="table"></datatable>-->
                            <!--
                            <datatable-pager v-model="page" type="abbreviated" :per-page="per_page"></datatable-pager>
                            -->
                            <!--                            <table class="table mt-10">
                                                            <thead>
                                                                <tr>
                                                                    <th>ID</th>
                                                                    <th>Name</th>
                                                                    <th>Subtitle</th>
                                                                    <th>Image</th>
                                                                    <th>Action</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr v-for="(category,index) of categories">
                                                                    <td>{{ category.id }}</td>
                                                                    <td>{{ category.name }}</td>
                                                                    <td>{{ category.subtitle }}</td>
                                                                    <td>
                                                                        <img :src="category.image_url" height="50" />
                                                                    </td>
                                                                    <td>
                                                                        <router-link :to="`/subcategories/${category.id}`" class="btn btn-primary">View Subcategories</router-link>
                                                                        <button class="btn btn-secondary" @click="edit_record = category">Edit</button>
                                                                        <button class="btn btn-danger" @click="deleteCategory(index,category.id)">Delete</button>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>-->
                            <b-row class="mb-2">
                                <b-col md="3" offset-md="8">
                                    <h6 class="box-title">Search</h6>
                                    <b-form-input
                                        id="filter-input"
                                        v-model="filter"
                                        type="search"
                                        placeholder="Search"
                                    ></b-form-input>
                                </b-col>
                                <b-col md="1" class="text-center">
                                    <button class="btn btn-primary btn_refresh" v-b-tooltip.hover :title="__('refresh')" @click="getSliders()">
                                        <i class="fa fa-refresh" aria-hidden="true"></i>
                                    </button>
                                </b-col>

                            </b-row>
                            <div class="table-responsive">
                            <b-table
                                :items="sliders"
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


                                <template #cell(image)="row">
                                    <img :src="row.item.image_url" height="50"/>
                                </template>
                                <template #cell(status)="row">
                                    <span v-if="row.item.status === 1" class="badge bg-success">Active</span>
                                    <span v-else class="badge bg-danger">Deactive</span>
                                </template>

                                <template #cell(actions)="row">
                                    <button class="btn btn-sm btn-primary" @click="edit_record = row.item" v-if="$can('home_slider_image_update')" v-b-tooltip.hover :title="__('edit')"><i class="fa fa-pencil"></i></button>
                                    <button class="btn btn-sm btn-danger" @click="deleteSlider(row.index,row.item.id)" v-if="$can('home_slider_image_delete')" v-b-tooltip.hover :title="__('delete')"><i class="fa fa-trash"></i></button>
                                </template>

                            </b-table>
                            </div>
                            <b-row>
                                <b-col md="2" class="my-1">
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
                                <b-col md="4" class="my-1" offset-md="6">
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
            v-if="create_new || edit_record"
            :record="edit_record"
            :categories="categories"
            :products="products"
            @modalClose="hideModal()"
        ></app-edit-record>
    </div>

</template>
<script>
import {VuejsDatatableFactory} from 'vuejs-datatable';
import EditRecord from './Edit.vue';
import axios from "axios";


export default {
    components: {
        VuejsDatatableFactory,
        'app-edit-record': EditRecord,
    },
    data: function () {
        return {
            create_new: false,
            fields: [
                {key: 'id', label: 'ID', sortable: true, sortDirection: 'desc'},
                {key: 'type', label: 'Type', sortable: true, class: 'text-center'},
                {key: 'type_name', label: 'Name', sortable: true, class: 'text-center'},
                {key: 'image', label: 'Image', class: 'text-center'},
                {key: 'status', label: 'Status', class: 'text-center'},
                {key: 'actions', label: __('actions')}
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

            sliders: [],
            isLoading: false,
            sectionStyle: 'style_1',
            max_visible_sliders: 12,
            max_col_in_single_row: 3,
            edit_record: null,
            categories: [],
            products: [],
        }
    },
    computed: {
        sortOptions() {
            // Create an options list from our fields
            return this.fields
                .filter(f => f.sortable)
                .map(f => {
                    return {text: f.label, value: f.key}
                })
        }
    },
    mounted() {
        // Set the initial number of items
        this.totalRows = this.sliders.length
    },
    watch: {
        $route(to, from) {
            this.showCreateModal();
        }
    },
    created: function () {
        this.showCreateModal();

        console.log('created');
        console.log(this.$apiUrl);
        this.$eventBus.$on('SliderSaved', (message) => {
            this.showMessage('success', message);
            this.getSliders();
        });
        this.getSliders();
        this.getCategories();
        this.getProducts();
    },
    methods: {
        getSliders() {
            this.isLoading = true
            axios.get(this.$apiUrl + '/home_slider_images')
                .then((response) => {
                    this.isLoading = false
                    let data = response.data;
                    this.sliders = data.data
                    this.totalRows = this.sliders.length
                    //console.log("Sliders : ", this.sliders);
                });
        },
        getCategories() {
            this.isLoading = true
            let url = this.$apiUrl + '/categories';
            axios.get(url)
                .then((response) => {
                    this.isLoading = false
                    let data = response.data;
                    this.categories = data.data
                });
        },
        getProducts() {

            this.isLoading = true
            let url = this.$apiUrl + '/products';
            axios.get(url)
                .then((response) => {
                    this.isLoading = false
                    let data = response.data;
                    this.products = data.data.products
                });
        },
        deleteSlider(index, id) {
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
                    axios.post(this.$apiUrl + '/home_slider_images/delete', postData)
                        .then((response) => {
                            this.isLoading = false
                            let data = response.data;
                            this.sliders.splice(index, 1)
                            // this.showSuccess(data.message);
                            this.showMessage("success", data.message);
                        });
                }
            });
        },
        showCreateModal(){
            let create = this.$route.params.create;
            if(create){
                this.create_new = true;
            }
        },
        hideModal() {
            this.create_new = false
            this.edit_record = false
            this.$router.push({path: '/home_sliders'});
        },

    }
};
</script>
