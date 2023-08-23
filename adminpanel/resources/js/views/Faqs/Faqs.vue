<template>
    <div>
        <div class="page-heading">
            <div class="page-title">
                <div class="row">
                    <div class="col-12 col-md-6 order-md-1 order-last">
                        <h3>Frequently Asked Questions</h3>
                    </div>
                    <div class="col-12 col-md-6 order-md-2 order-first">
                        <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><router-link to="/dashboard">{{ __('dashboard') }}</router-link></li>
                                <li class="breadcrumb-item active" aria-current="page">Frequently Asked Questions</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
            <section class="section">
                <div class="card">
                    <div class="card-header">
                        <h4 class="card-title">FAQs List</h4>
                        <span class="pull-right">
                            <button class="btn btn-primary"  @click="create_new=true">Add</button>
                        </span>
                    </div>
                    <div class="card-body">

                        <b-row class="mb-2">
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
                                <button class="btn btn-primary btn_refresh" v-b-tooltip.hover :title="__('refresh')" @click="getFaqs()">
                                    <i class="fa fa-refresh" aria-hidden="true"></i>
                                </button>
                            </b-col>
                        </b-row>
<!--                        <b-row>
                            <template v-for="faq in faqs">
                                <ul class="list-group">
                                    <li class="list-group-item" style="color:#435ebe;">
                                        <a>{{ faq.question }}</a>
                                    </li>
                                    <li class="list-group-item">
                                        <p> {{ faq.question }}</p>
                                        <a href="javascript:void(0)"><span class="badge bg-danger pull-right">Delete</span></a>
                                        <a href="javascript:void(0)"><span class="badge bg-success pull-right">Edit | Answer</span></a>
                                    </li>
                                </ul>
                            </template>
                        </b-row>-->

                        <b-table
                            :items="faqs"
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
                            <template #cell(faqs)="row">
                                <a href="javascript:void(0)" style="color:#435ebe;">{{ row.item.question }}</a>
                                <p> {{ row.item.answer }}</p>
                            </template>
                            <template #cell(actions)="row">
                                <button class="btn btn-sm btn-primary" @click="edit_record = row.item" v-b-tooltip.hover :title="__('edit')"><i class="fa fa-pencil"></i> {{ __('edit') }} |
                                    {{ __('answer') }}</button>
                                <button class="btn btn-sm btn-danger" @click="deleteSocialMedia(row.index,row.item.id)" v-b-tooltip.hover :title="__('delete')"><i class="fa fa-trash"></i>
                                    {{ __('delete') }}</button>
                            </template>
                        </b-table>
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
        <!-- Add / Edit -->
        <app-edit-record
            v-if="create_new || edit_record"
            :record="edit_record"
            @modalClose="hideModal()"
        ></app-edit-record>
    </div>
</template>
<script>
import EditRecord from './Edit';
import axios from "axios";

export default {
    components: {
        'app-edit-record' : EditRecord,
    },
    data: function() {
        return {
            fields: [
                /*{ key: 'id', label: 'ID', sortable: true, sortDirection: 'desc' },*/
                { key: 'faqs', label: 'Frequently Asked Questions', sortable: true},
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
            create_new : null,
            edit_record : null,
            faqs: [],
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
        this.totalRows = this.faqs.length
    },
    created: function() {
        this.$eventBus.$on('faqSaved', (message) => {
            //this.showSuccess(message);
            this.showMessage("success", message);
            this.getFaqs();
            this.create_new = null;
        });
        this.getFaqs();
    },
    methods: {
        getFaqs(){
            this.isLoading = true
            axios.get(this.$apiUrl + '/faqs')
                .then((response) => {
                    this.faqs = response.data.data;
                    this.totalRows = this.faqs.length
                    this.isLoading = false;
                });
        },
        deleteSocialMedia(index, id){
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
                    axios.post(this.$apiUrl + '/faqs/delete',postData)
                        .then((response) => {
                            this.isLoading = false
                            this.faqs.splice(index, 1)
                            //this.showSuccess(response.data.message)
                            this.showMessage("success", response.data.message);
                        });
                }
            });
        },
        hideModal() {
            this.create_new = false
            this.edit_record = false
        },
    }
};
</script>
