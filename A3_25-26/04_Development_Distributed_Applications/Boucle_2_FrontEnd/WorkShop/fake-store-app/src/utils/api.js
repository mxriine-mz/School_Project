import axios from "axios";

const apiClient = axios.create({
  baseURL: "https://fakestoreapi.com",
  headers: {
    "Content-Type": "application/json",
  },
});

export const getProducts = async () => {
    try {
        const response = await apiClient.get("/products");
        return response.data;
    } catch (error) {
        console.error("Error fetching products:", error);
        throw error;
    }
};

// Récupère UN seul produit grâce à son id (route /products/:id de la Fake Store API)
export const getProduct = async (id) => {
    try {
        const response = await apiClient.get(`/products/${id}`);
        return response.data;
    } catch (error) {
        console.error(`Error fetching product ${id}:`, error);
        throw error;
    }
};

// Authentifie un utilisateur (route /auth/login de la Fake Store API)
// Reçoit un identifiant + mot de passe, renvoie un objet { token } en cas de succès
export const loginUser = async (username, password) => {
    try {
        const response = await apiClient.post("/auth/login", { username, password });
        return response.data;
    } catch (error) {
        console.error("Error logging in:", error);
        throw error;
    }
};