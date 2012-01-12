#Artworker

The Artworker plugin provides many of the basic functions needed when dealing with a collection of different fine artwork and artists. The plugin does this by providing custom attributes in an easy to use way that are universally needed (based on museum standards) when dealing with artwork and artists. 

##Installation

  script/plugin install git://github.com/datalab/artworker.git

##Usage

###In Your Artwork Model

In the migration file for your artwork model, make sure you have columns for the following standard artwork attributes:

- Title Column => Either string or text.
- Date Column => Either string or text.
- Height Column => Decimal, that defaults to 0.
- Width Column => Decimal, that defaults to 0.
- Depth Column => Decimal, that defaults to 0.

Optionally, you can define other columns for artworker. Those columns can provide added functionality to override the defaults:

- Use Fractions Column => Boolean, default can be set to true if you want to use fractions instead of decimals.
- Use Metric System Column => Boolean, default can be set to true if you want to use centimeters instead of inches.

You can also assign other dimension types like paper, or framed, or base. Simply add those dimensions as decimal columns, making sure they default to 0.

Here is a sample migration that includes the basic columns, optional columns, and columns to record the frame dimensions:

  class CreateArtworks < ActiveRecord::Migration
    def self.up
      create_table :artworks do |t|
        t.string :title
        t.string :date
        t.decimal :height, :null => false, :default => 0
        t.decimal :width, :null => false, :default => 0
        t.decimal :depth, :null => false, :default => 0
        t.decimal :framed_height, :null => false, :default => 0
        t.decimal :framed_width, :null => false, :default => 0
        t.decimal :framed_depth, :null => false, :default => 0
        t.boolean :use_fractions, :default => true, :null => false
        t.boolean :use_metric, :default => false, :null => false
        t.timestamps
      end
    end
 
    def self.down
      drop_table :artworks
    end
  end

Once you have created your migration file and migrated your database. You can add the 'uses_artworker_artwork' command to your model. You may alter the options to match the columns in your database (though it may not be necessary if your columns match the default options). Here is the sample usage of the 'uses_artworker_artwork' command for the model based on the above sample migration:

  uses_artworker_artwork :title => :title,
                         :date => :date,
                         :use_fractions => :use_fractions,
                         :use_metric => :use_metric,
                         :dimensions => { :dimensions => [:height, :width, :depth], :framed_dimensions => [:framed_height, :framed_width, :framed_depth]}

You should now be able to use the attributes that Artworker provides. Below is a list of those attributes for the sample model:

- title_with_date
- italic_title_with_date
- height
- width
- depth
- framed_height
- framed_width
- framed_depth
- height_in_inches
- height_in_centimeters
- width_in_inches
- width_in_centimeters
- depth_in_inches
- depth_in_centimeters
- framed_height_in_inches
- framed_height_in_centimeters
- framed_width_in_inches
- framed_width_in_centimeters
- framed_depth_in_inches
- framed_depth_in_centimeters
- dimensions
- dimensions_in_inches
- dimensions_in_centimeters
- framed_dimensions
- framed_dimensions_in_inches
- framed_dimensions_in_centimeters

###In Your Artist Model

In the migration file for your artist model, make sure you have columns for the following standard artist attributes:

- First Name Column => Either string or text.
- Last Name Column => Either string or text.
- Birth Date Column => Either integer, string or text.
- Death Date Column => Either integer, string or text.
- Nationlity Column => Either string or text.

Here is a sample migration that includes the basic columns:

  class CreateArtists < ActiveRecord::Migration
    def self.up
      create_table :artists do |t|
        t.string :firstname
        t.string :lastname
        t.string :birth
        t.string :death
        t.string :nationality
        t.timestamps
      end
    end
  
    def self.down
      drop_table :artists
    end
  end

Once you have created your migration file and migrated your database. You can add the 'uses_artworker_artist' command to your model. You may alter the options to match the columns in your database (though it may not be necessary if your columns match the default options). Here is the sample usage of the 'uses_artworker_artist' command for the model based on the above sample migration:

  	uses_artworker_artist :firstname => :firstname,
                      :lastname => :lastname,
                      :birth => :birth,
                      :death => :death,
                      :nationality => :nationality

You should now be able to use the attributes that Artworker provides. Below is a list of those attributes for the sample model:

- fullname
- dates
- fullname_with_dates
- fullname_with_nationality_and_dates

##Troubleshooting and FAQs

<b>Why did you make this plugin?</b>

There's only so many times that you can write the same code in project to project before you get really sick of it. We've made enough sites for organizations in the art world to know this will alleviate our need for repetitious code. 

<b>What are the default options?</b>

For the artwork options, the defaults are:

  :title => :title
  :date => :date
  :use_fractions => :use_fractions (or false if column does not exist)
  :use_metric => :use_metric (or false if column does not exist)
  :dimensions => { :dimensions => [:height, :width, :depth] }

For the artist options, the defaults are:

  :firstname => :firstname
  :lastname => :lastname
  :birth => :birth
  :death => :death
  :nationality => :nationality

<b>The fractions aren't formatting properly in an input field?</b>

Yes, this is as Rails intended. You can override this by explicitly declaring the value of the input field.

<b>Why can't this plugin generate a standard migration, model, controller, etc. for me?</b>

Most people have their own preference when it comes to scaffold generation, and they usually go so far as to create their own. It doesn't seem like putting yet another scaffold out in the wild makes much sense.

<b>Why doesn't this plugin also handle images?</b>

Everybody has their own methods for working with images, so it doesn't seem too advantageous at this point to include that functionality. With that being said, it may get added in the future.

<b>Where are the tests?</b>

They are coming...

##Development
This project can be found on github at the following URL.

http://github.com/datalab/artworker/

We encourage you to fork this project and make any changes you would like!