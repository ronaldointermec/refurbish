const { Model, DataTypes } = require('sequelize');


class Order extends Model {

    static init(sequelize) {
        super.init({
            os: DataTypes.STRING,
            contract_type: DataTypes.STRING,
            customer_name: DataTypes.STRING,
            part_number: DataTypes.STRING,
            serial_number: DataTypes.STRING,
            days: DataTypes.STRING,
            created_by: DataTypes.STRING,
            updated_by: DataTypes.STRING,
        }, { sequelize });

    }
     static associate(models){
      this.hasMany(models.Requisition,{foreignKey: 'order_id'})
      this.hasMany(models.MicrosigaLoan,{foreignKey: 'order_id'})
      
    }
 
}

module.exports = Order;