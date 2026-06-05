// Page de connexion : elle se contente d'afficher le formulaire réutilisable LoginForm
import LoginForm from "../../components/LoginForm";

export default function LoginPage() {
  return (
    <div className="container mx-auto p-4">
      <LoginForm />
    </div>
  );
}
