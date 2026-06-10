import api from "../api/axios.js";

// Service fruits : regroupe tous les appels HTTP vers l'API. Les composants
// passent par ce service (separation des responsabilites). Le backend repond
// { success, data } : on renvoie directement la partie utile.

export const getFruits = async () => {
  const { data } = await api.get("/fruits");
  return data.data; // tableau de fruits
};

export const getFruit = async (id) => {
  const { data } = await api.get(`/fruits/${id}`);
  return data.data;
};

export const createFruit = async (fruit) => {
  const { data } = await api.post("/fruits", fruit);
  return data.data;
};

export const updateFruit = async (id, fruit) => {
  const { data } = await api.put(`/fruits/${id}`, fruit);
  return data.data;
};

export const deleteFruit = async (id) => {
  const { data } = await api.delete(`/fruits/${id}`);
  return data.data;
};
