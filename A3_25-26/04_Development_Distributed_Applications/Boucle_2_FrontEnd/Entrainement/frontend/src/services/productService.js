import api from "../api/axios.js";

// Service produits : regroupe tous les appels HTTP vers l'API. Les composants
// n'appellent jamais Axios directement, ils passent par ce service (separation
// des responsabilites). Chaque fonction renvoie directement les donnees utiles
// (le backend repond { success, data }).

export const getProducts = async () => {
  const { data } = await api.get("/products");
  return data.data; // tableau de produits
};

export const getProduct = async (id) => {
  const { data } = await api.get(`/products/${id}`);
  return data.data;
};

export const createProduct = async (product) => {
  const { data } = await api.post("/products", product);
  return data.data;
};

export const updateProduct = async (id, product) => {
  const { data } = await api.put(`/products/${id}`, product);
  return data.data;
};

export const deleteProduct = async (id) => {
  const { data } = await api.delete(`/products/${id}`);
  return data.data;
};
