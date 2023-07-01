
# Property Rental Management

This database is designed for a Property Rental Agency (PRA) scenario where the agency facilitates the mediation between property owners and tenants across multiple cities in India. The system includes users such as owners, tenants, managers, and a superuser who is the DBA. The DBA has the authority to add, delete, and modify users, while managers can manage properties. Users can act as both owners and tenants, and properties can be residential or commercial. The database captures property rental details, including rent per month, start and end dates, yearly rent hike, agency commission, etc.

## Contributors
- Utkarsh Tiwari
- Sarvesh Borole
- Nishit Poddar
- Rohit Das


## Entity-Relationship (ER) Model

The ER model represents the entities, attributes, and relationships in the Property Rental Agency scenario.

### Entities:
- User: Represents a user of the system (owner, tenant, manager). Contains attributes such as AdharID, name, age, address, and phone numbers.
- Property: Represents a property available for rent. Includes attributes like propertyID, availability dates, rent per month, area, number of bedrooms, number of floors, year of construction, locality, address, and facilities.
- RentHistory: Represents the rental history of a property. Includes attributes such as tenant, rent per month, start and end dates, rent hike percentage, agency commission, etc.

### Relationships:
- Owns: Represents the ownership relationship between users and properties. A user can own zero to many properties, and each property is owned by one user.
- Rents: Represents the rental relationship between properties and tenants. A property can be rented to zero to many tenants, and each tenant can rent zero to many properties.

## Relational Schema Design

Based on the ER model, the following relational schema is designed:

### User Table:
- UserID (Primary Key)
- AdharID
- Name
- Age
- Address
- PhoneNumbers
- LoginCredentials

### Property Table:
- PropertyID (Primary Key)
- OwnerID (Foreign Key references User.UserID)
- AvailabilityFrom
- AvailabilityTo
- RentPerMonth
- Area
- Bedrooms
- Floors
- YearOfConstruction
- Locality
- Address
- Facilities

### RentHistory Table:
- RentHistoryID (Primary Key)
- PropertyID (Foreign Key references Property.PropertyID)
- TenantID (Foreign Key references User.UserID)
- RentPerMonth
- StartDate
- EndDate
- RentHikePercentage
- AgencyCommission
- OtherInfo

## Functionality

The following functionalities are expected to be implemented in the Property Rental Agency database:

1. DBA privileges: The DBA can add users to the database with necessary privileges.
2. Add/Delete/Update Property: DBA and managers can add, delete, and update property records.
3. Owner Property Management: Owners can only add, delete, and update their own property records.
4. Add Property Rent Details: Admin and managers can add rental details once a property is rented by a tenant.
5. Rent History Report: Generate a report on the rental history of a property.
6. Search Available Properties: Users can search for available properties for rent within a given city, locality, or price range.
7. Property Status Check: All users can check the status of a property based on the property ID.
8. Tenant Data Restrictions: Tenants can only view available properties and cannot insert, delete, or modify any data in the database.
