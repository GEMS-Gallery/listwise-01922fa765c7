import { backend } from 'declarations/backend';

document.addEventListener('DOMContentLoaded', async () => {
    const form = document.getElementById('add-item-form');
    const input = document.getElementById('new-item');
    const list = document.getElementById('shopping-list');

    // Load initial items
    await loadItems();

    // Add new item
    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        const text = input.value.trim();
        if (text) {
            await backend.addItem(text);
            input.value = '';
            await loadItems();
        }
    });

    // Load and display items
    async function loadItems() {
        const items = await backend.getItems();
        list.innerHTML = '';
        items.forEach(item => {
            const li = document.createElement('li');
            li.innerHTML = `
                <span class="${item.completed ? 'completed' : ''}">${item.text}</span>
                <button class="delete-btn"><i class="fas fa-trash"></i></button>
            `;
            li.dataset.id = item.id;
            li.addEventListener('click', toggleItem);
            li.querySelector('.delete-btn').addEventListener('click', deleteItem);
            list.appendChild(li);
        });
    }

    // Toggle item completion
    async function toggleItem(e) {
        if (e.target.tagName === 'BUTTON') return; // Ignore if delete button was clicked
        const id = parseInt(this.dataset.id);
        await backend.toggleItem(id);
        await loadItems();
    }

    // Delete item
    async function deleteItem(e) {
        e.stopPropagation();
        const id = parseInt(this.parentElement.dataset.id);
        await backend.deleteItem(id);
        await loadItems();
    }
});
