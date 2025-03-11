import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "favorite" ]
  connect() {
    console.log("stimulus connecté !");
  }

  // toggle(event) {
  //   event.preventDefault();
  //   console.log("click");
  //   const favorite = this.favoriteTargets[0];

  //   fetch(`/favorites/${favorite.dataset.id}`, {
  //     method: 'POST',
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/json"
  //     },
  //     body: JSON.stringify({ favorite: { id: favorite.dataset.id } })
  //   })
  //   .then(response => response.json())
  //   .then((data) => {
  //     console.log(data);
  //     if (data.favorited) {
  //       favorite.classList.add('Ajouté aux favoris!');
  //     } else {
  //       favorite.classList.remove('Retiré des favoris!');
  //     }
  //   });
  // }
}
