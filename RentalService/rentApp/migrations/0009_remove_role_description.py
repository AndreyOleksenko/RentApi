# Generated by Django 5.1.6 on 2025-03-05 08:53

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('rentApp', '0008_rental_approved_at_rental_approved_by_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='role',
            name='description',
        ),
    ]
