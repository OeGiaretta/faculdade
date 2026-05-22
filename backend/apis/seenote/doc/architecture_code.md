# 🚀 FLUXO COMPLETO (IMPORTANTE)

Vamos seguir uma requisição real:

---

## 🔥 Exemplo: `GET /nota/1001`

### 1. ROUTES

`/nota/1001` → envia para `controller.getById`

---

### 2. CONTROLLER

* Recebe request
* Chama `service.getById("1001")`

---

### 3. SERVICE

* Procura no Map: `notas["1001"]`
* Retorna dados

---

### 4. CONTROLLER (de novo)

* Transforma em JSON
* Retorna `Response.ok(...)`

---

### 5. CLIENTE RECEBE

```json
{
  "numero": "1001",
  "empresa": "Mercado Central"
}
```

---

# 🧠 RESUMO SIMPLES (ESSÊNCIA)

## 🟣 ROUTES

👉 “qual URL existe?”

---

## 🔵 CONTROLLER

👉 “como responde HTTP?”

---

## 🟢 SERVICE

👉 “o que o sistema faz?”

---

## 🟡 DATA

👉 “onde os dados ficam?”
