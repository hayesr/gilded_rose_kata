require 'delegate'

class ItemUpdater
  attr_reader :item
  def initialize(item)
    @item = item
  end
  
  def self.appropriate_subtype_for(item)
    if item.name == 'Aged Brie'
      subtype = BrieUpdater
    else
      subtype = self
    end
    subtype.new(item)
  end

  def update
    update_quality_before_expiration
    age!
    update_quality_after_expiration
  end

  private
  
  def conjured?
    item.name == 'Conjured Mana Cake'
  end

  def decrease_quality
    if conjured?
      item.quality -= 2
    else
      item.quality -= 1
    end
  end
  
  def age!
    if item.name != 'Sulfuras, Hand of Ragnaros'
      item.sell_in -= 1
    end
  end
  
  def expired?
    item.sell_in < 0
  end
  
  def update_quality_before_expiration
    case item.name
    when 'Aged Brie'
      update_aged_brie_before_expiration
    when 'Backstage passes to a TAFKAL80ETC concert'
      update_backstage_pass_before_expiration
    when 'Sulfuras, Hand of Ragnaros'
      update_sulfuras_before_expiration
    else
      update_item_before_expiration
    end

  end
  
  def update_item_before_expiration
    if item.quality > 0
      decrease_quality
    end
  end
  
  def update_sulfuras_before_expiration
    # this space intentionally left blank
  end
  
  def update_aged_brie_before_expiration
    if item.quality < 50
      item.quality += 1
    end
  end
  
  def update_backstage_pass_before_expiration
    item.quality += backstage_pass_coolness_factor

    if item.quality > 50
      item.quality = 50
    end
  end
  
  def backstage_pass_coolness_factor
    case item.sell_in
    when (1..5)  ; 3
    when (6..10) ; 2
    else         ; 1
    end
  end
  
  def update_quality_after_expiration
    return unless expired?

    if item.name != "Aged Brie"
      if item.name != 'Backstage passes to a TAFKAL80ETC concert'
        if item.quality > 0
          if item.name != 'Sulfuras, Hand of Ragnaros'
            decrease_quality
          end
        end
      else
        item.quality = 0
      end
    else
      if item.quality < 50
        item.quality += 1
      end
    end
  end
end

class BrieUpdater < ItemUpdater
end



def update_quality(items)
  items.each do |item|
    updater = ItemUpdater.appropriate_subtype_for(item)
    updater.update
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

