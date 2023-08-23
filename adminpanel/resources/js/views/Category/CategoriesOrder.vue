<template>
    <div>
        <div class="page-heading">
            <div class="row">
                <div class="col-12 col-md-6 order-md-1 order-last">
                    <h3>{{ __('categories_order') }}</h3>
                </div>
                <div class="col-12 col-md-6 order-md-2 order-first">
                    <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><router-link to="/dashboard">{{ __('dashboard') }}</router-link></li>
                            <li class="breadcrumb-item active" aria-current="page">{{ __('categories_order') }}</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <div class="row">
                <div class="col-12 col-md-12 order-md-1 order-last">
                    <div class="card">
                        <div class="card-header">
                            <h4>{{ __('categories_order_list') }}</h4>
                        </div>
                        <div class="card-body">
                            <b-row>
                                <b-col md="6">
                                    <div class="mb-2 d-flex justify-content-between align-items-center">
                                        <div class="form-check form-switch">
                                            <label> <input type="checkbox" v-model="editable" class="form-check-input">
                                                {{ __('enable_drag_and_drop') }}</label>
                                        </div>
                                        <button type="button" class="btn btn-sm btn-primary" @click="orderList">{{ __('sort_by_original_order') }}</button>
                                    </div>
                                </b-col>
                            </b-row>
                            <b-row>
                                <b-col md="6" style="overflow-y:scroll;height:300px;">

                                    <ul id="sortable-row" class="list-group">
                                        <draggable class="list-group" tag="ul" v-model="list" v-bind="dragOptions" :move="onMove" :options="{ animation:200 }" @start="isDragging=true" @end="isDragging=false"
                                        @change="updateList()">

                                                <li v-for="category in list" :key="category.row_order" class="list-group-item d-flex justify-content-between align-items-center">
                                                    <span>
                                                        <span class="text-left mr-2">{{ category.row_order }}</span>
                                                        <span class="text-left mr-2">-</span>
                                                        <span class="text-left mr-2">{{ category.id }} </span>
                                                        <span class="text-left mr-2"><img :src="category.image_url" height="30"></span>
                                                        <span class="text-left mr-2">{{ category.name }}</span>
                                                    </span>
                                                    <span><i class="fa fa-arrows"></i></span>
                                                </li>
                                        </draggable>
                                    </ul>
                                </b-col>
                            </b-row>
                            <b-row>
                                <div class="col-md-6 mt-4">
                                    <button type="type" @click="updateCategoriesOrder()" class="btn btn-success" :disabled="isLoading">
                                        {{ __('save_order') }} <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
                                    </button>
                                </div>
                            </b-row>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import draggable from 'vuedraggable';
import axios from "axios";
export default {
    components: {
        draggable,
    },
    data: function() {
        return {
            categories: [],
            list: [],
            editable: true,
            isDragging: false,
            delayedDragging: false,
            isLoading: false,
        }
    },
    computed: {
        dragOptions() {
            return {
                animation: 0,
                group: "description",
                disabled: !this.editable,
                ghostClass: "ghost"
            };
        },
        listString() {
            return JSON.stringify(this.list, null, 2);
        },
        list2String() {
            return JSON.stringify(this.list2, null, 2);
        }
    },
    watch: {
        isDragging(newValue) {
            if (newValue) {
                this.delayedDragging = true;
                return;
            }
            this.$nextTick(() => {
                this.delayedDragging = false;
            });
        }
    },
    mounted() {

    },
    created: function() {
        this.$eventBus.$on('categorySaved', (message) => {
            //console.log('eventBus : categorySaved');
            //this.showSuccess(message);
            this.showMessage("success", message);
            this.getCategories();
        });
        this.getCategories();
    },
    methods: {
        orderList() {
            this.getCategories();
            /*this.list = this.list.sort((one, two) => {
                return one.row_order - two.row_order;
            });*/
        },
        onMove({ relatedContext, draggedContext }) {
            const relatedElement = relatedContext.element;
            const draggedElement = draggedContext.element;
            return (
                (!relatedElement || !relatedElement.fixed) && !draggedElement.fixed
            );
        },
        updateList(){
            this.list.map((category, index) => {
                    category.row_order = index + 1;
            });
        },
        getCategories(){
            axios.get(this.$apiUrl + '/categories/row_order')
                .then((response) => {
                    let data = response.data;
                    this.list = data.data.map((category, index) => {
                        return {
                            id:category.id,
                            name:category.name,
                            row_order: category.row_order,
                            image_url: category.image_url,
                            fixed: false
                        };
                    })
                });
        },
        updateCategoriesOrder(){
            this.isLoading = true;
            let formData = this.list;
            let url = this.$apiUrl + '/categories/updateOrder';
            axios.post(url, formData).then(res => {
                let data = res.data;
                if (data.status === 1) {
                    //this.showSuccess(data.message);
                    this.showMessage("success", data.message);
                    this.isLoading = false;
                    this.getCategories();
                }else{
                    this.showError(data.message);
                    this.isLoading = false;
                }
            }).catch(error => {
                this.isLoading = false;
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError(__('something_went_wrong'));
                }
            });

        },
    }
};
</script>
<style scoped>
.flip-list-move {
    transition: transform 0.5s;
}

.no-move {
    transition: transform 0s;
}

.ghost {
    opacity: 0.5;
    background: #c8ebfb;
}

.list-group {
    min-height: 20px;
}

.list-group-item {
    cursor: move;
}

.list-group-item i {
    cursor: pointer;
}
</style>
