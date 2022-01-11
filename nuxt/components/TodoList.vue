<template>
<div id="shopping-list"> 
    <div class="container">
        <div class="row">
            <div class="col-xs-12 col-md-12"><h1>Vue School Project</h1></div>
        </div>

    <div class="row">
        <div class="col-xs-12 col-md-8">
            <h1>{{ header || 'Welcome' }}</h1>
        </div>
        <div class="col-xs-6 col-md-4">
            <button @click="makeEdit(false)" v-if="editing" class="btn btn-warning">Cancel</button>
            <button @click="makeEdit(true)" v-else class="btn btn-primary">Edit</button>
        </div>
    </div>
    
    <div class="row">
        <div class="add-item-form" v-if="editing">
            <div class="row">
                <div class="col-xs-6 col-md-4">
                <input
                    class="newItemInput"
                    type="text"
                    v-model="newItemQty"
                    placeholder="##"
                    size=3
                >
                
                <input 
                    class="newItemInput"
                    @keyup.enter="saveItem" 
                    type="text" v-model="newItem" placeholder="Add an Item"
                    > 
                <span class="counter">{{characterCount}}/200</span>
                </div>
                <p>
                    <label>
                        <input type="checkbox" v-model="newItemPriorityHigh"> 
                        High Priority 
                    </label>
                </p>

                </div>

                <div class="col-md-4">
                    <button @click="saveItem" 
                    :disabled="newItem.length === 0" class="btn btn-primary">
                            Save Item
                        </button>
                </div>

            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-xs-6 col-md-4 shoppinglist">
            <p v-if="items.length === 0" class="emptyStateText">Click edit to add items to the list!</p>
        
                <ul> 
                    <li v-for="item in reversedItems" 
                    @click="togglePurchased(item)"
                    :key="item.id"
                    :class="{strikeout: item.purchased, priority: item.highPriority}"
                    >
                        {{item.qty}} {{item.label}}
                    </li>
                </ul>
        </div>
    </div>
</div>
</template>

<script> 
const shoppingListApp = Vue.createApp({
        data() {
            return {
                header: "Shopping List App",
                editing: false, 
                newItem: '',
                newItemQty: 0, 
                newItemPriorityHigh: false,
                items: [ 
                        {id: 1, qty: 10, label: 'party hats', purchased: true, highPriority: true},
                        {id: 2, qty: 1, label: 'board boards', purchased: false,  highPriority: true}, 
                        {id: 3, qty: 20, label: 'cups', purchased: true,  highPriority: false}

                    ]
            }
        },
        computed: { 
            characterCount() { 
                return this.newItem.length
            },
            reversedItems() { 
                return [...this.items].reverse() 
            }
        },
        methods: { 
            saveItem() { 
                this.items.push({id:this.items.length + 1, label: this.newItem, highPriority: this.newItemPriorityHigh, purchased: false, qty: this.newItemQty})                   
                this.newItem = "" 
                this.newItemQty = 0
            },
            makeEdit(editing){ 
                this.editing = editing
                this.newItem = ""
                this.newItemQty = 0
            },
            togglePurchased(item) { 
                item.purchased = !item.purchased
            }
        }
    })
    .mount('#shopping-list')
</script> 

<style scoped>
.newItemInput { 
    display: flexbox;
    margin: 12px auto;
}

.emptyStateText { 
    color: red;
}

.strikeout { 
    text-decoration: line-through;
}

.underlined { 
    text-decoration: underline;
}

.priority { 
    color: chocolate;
    font-weight: 600;
}

.shoppinglist { 
    width: 100%;
    display: block; 
    background: lightblue;
    border: 1px darkblue;
    border-radius: 1rem;
    margin: 24px 12px !important; 
    padding: 12px 12px; 

}

li {
    cursor: pointer;
    list-style: disc;
}

/* Extra small devices (phones, less than 768px)
/* No media query since this is the default in Bootstrap */

/* Small devices (tablets, 768px and up) */
/* @media (min-width: @screen-sm-min) { ... } */

/* Medium devices (desktops, 992px and up) */
/* @media (min-width: @screen-md-min) { ... } */

/* Large devices (large desktops, 1200px and up) */
/* @media (min-width: @screen-lg-min) { ... } */ 


</style>