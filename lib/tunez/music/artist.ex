defmodule Tunez.Music.Artist do
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

  postgres do
    table "artists"
    repo Tunez.Repo
  end

  attributes do
    uuid_v7_primary_key :id do
      primary_key? true
    end

    attribute :name, :string do
      allow_nil? false
    end

    attribute :previous_names, {:array, :string} do
      default []
    end

    attribute :biography, :string

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  actions do
    create :create do
      accept [:name, :biography]
    end
    read :read do
      primary? true
    end
    update :update do
      require_atomic? false
      accept [:name, :biography, :previous_names]
      change Tunez.Music.Changes.UpdatePreviousNames, where: [changing(:name)]


    end

    defaults [ :destroy]
    default_accept [:name, :biography, :previous_names]

  end

# Context: Adding a rsort for the albums relatinoship
relationships do
  has_many :albums, Tunez.Music.Album do
    sort year_released: :desc
  end
end




end
