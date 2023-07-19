'use strict';

const sequelize = require('sequelize');

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable('reasons',
      {
        id: {
          type: Sequelize.INTEGER,
          primaryKey: true,
          autoIncrement: true,
          allowNull: false,
        },
        description: {
          type: Sequelize.STRING,
          allowNull: false,
          unique: true,
        },
        created_by: {
          type: Sequelize.STRING,
          allowNull: false,
        },
        updated_by: {
          type: Sequelize.STRING,
          allowNull: true,
        },
        created_at: {
          type: Sequelize.DATE,
          allowNull: false,
        },
        updated_at: {
          type: Sequelize.DATE,
          allowNull: false,
        },

      });

  },

  down: (queryInterface, Sequelize) => {

    return queryInterface.dropTable('reasons');

  }
};
